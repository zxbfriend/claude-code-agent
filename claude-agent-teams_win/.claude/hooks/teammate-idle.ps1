# TeammateIdle Hook - PowerShell Version for Windows
# 运行于Agent空闲时，检查是否有可认领的任务
# 退出码: 0 = 允许空闲, 2 = 阻止空闲（有可认领任务）

param(
    [Parameter(ValueFromPipeline = $true)]
    [string]$JsonInput = ""
)

# 如果没有JSON输入，尝试从stdin读取
if ([string]::IsNullOrEmpty($JsonInput)) {
    $JsonInput = [System.Console]::In.ReadToEnd()
}

# 如果无输入，允许空闲
if ([string]::IsNullOrEmpty($JsonInput.Trim())) {
    exit 0
}

try {
    $data = $JsonInput | ConvertFrom-Json
}
catch {
    # JSON解析失败，允许空闲
    exit 0
}

$teammate = $data.teammate_name
$teamName = $data.team_name

# 如果缺少关键信息，允许空闲
if ([string]::IsNullOrEmpty($teamName) -or [string]::IsNullOrEmpty($teammate)) {
    exit 0
}

# 查找最新的 TASK-LIST.md
$taskListPath = ""
if (Test-Path "outputs") {
    # 查找outputs目录下最新的TASK-LIST.md
    $taskLists = Get-ChildItem -Path "outputs" -Recurse -Filter "TASK-LIST.md" -ErrorAction SilentlyContinue | 
                 Sort-Object LastWriteTime -Descending
    
    if ($taskLists.Count -gt 0) {
        $taskListPath = $taskLists[0].FullName
    }
}

# 如果找不到任务列表，允许空闲
if ([string]::IsNullOrEmpty($taskListPath) -or -not (Test-Path $taskListPath)) {
    exit 0
}

# 读取TASK-LIST.md内容
try {
    $content = Get-Content -Path $taskListPath -Raw
}
catch {
    # 读取失败，允许空闲
    exit 0
}

# 从Markdown中提取JSON块
# 查找 ```json ... ``` 代码块
$jsonMatch = [regex]::Match($content, '```json\s*(\[.*?\])\s*```', [System.Text.RegularExpressions.RegexOptions]::Singleline)

if (-not $jsonMatch.Success) {
    # 找不到JSON块，允许空闲
    exit 0
}

$jsonString = $jsonMatch.Groups[1].Value

# 解析JSON数组
try {
    $tasks = $jsonString | ConvertFrom-Json
}
catch {
    # JSON解析失败，允许空闲
    exit 0
}

# 确保tasks是数组
if ($tasks -isnot [System.Collections.IEnumerable] -or $tasks -is [string]) {
    $tasks = @($tasks)
}

# 构建已完成任务的ID集合
$completedIds = @()
foreach ($task in $tasks) {
    if ($task.status -eq "completed") {
        $completedIds += $task.id
    }
}

# 计算可认领的任务数
$claimableCount = 0
foreach ($task in $tasks) {
    $status = $task.status
    $assignee = $task.assignee
    $dependsOn = $task.depends_on
    
    # 必须是pending状态
    if ($status -ne "pending") {
        continue
    }
    
    # 必须分配给该Agent或未分配
    if (-not [string]::IsNullOrEmpty($assignee)) {
        if ($assignee -ne $teammate -and $assignee -ne "unassigned" -and $assignee -ne "") {
            continue
        }
    }
    
    # 所有依赖都必须完成
    $allDepsDone = $true
    if ($null -ne $dependsOn -and $dependsOn -is [System.Collections.IEnumerable]) {
        foreach ($dep in $dependsOn) {
            if ($completedIds -notcontains $dep) {
                $allDepsDone = $false
                break
            }
        }
    }
    
    if (-not $allDepsDone) {
        continue
    }
    
    # 这个任务可认领
    $claimableCount++
}

# 如果有可认领任务，阻止空闲
if ($claimableCount -gt 0) {
    Write-Host "Teammate '$teammate': $claimableCount claimable task(s) available in the task list." -ForegroundColor Yellow
    Write-Host "Check TASK-LIST.md for tasks assigned to you or unassigned tasks whose dependencies are complete." -ForegroundColor Yellow
    exit 2
}

# 没有可认领任务，允许空闲
exit 0

# TaskCompleted Hook - PowerShell Version for Windows
# 运行于任务完成时，防止编码任务直接提交到main/master
# 退出码: 0 = 允许完成, 2 = 拒绝完成

param(
    [Parameter(ValueFromPipeline = $true)]
    [string]$JsonInput = ""
)

# 如果没有JSON输入，尝试从stdin读取
if ([string]::IsNullOrEmpty($JsonInput)) {
    $JsonInput = [System.Console]::In.ReadToEnd()
}

# 如果仍无输入，允许完成（可能Hook集成有问题）
if ([string]::IsNullOrEmpty($JsonInput.Trim())) {
    exit 0
}

try {
    $data = $JsonInput | ConvertFrom-Json
}
catch {
    # JSON解析失败，允许完成
    exit 0
}

# 提取任务信息
$taskSubject = $data.task_subject
$teammateName = $data.teammate_name

# 判断是否为编码任务的逻辑
$isCodingTask = $false

# 策略A: teammate_name 是否为已知编码Agent
$codingAgents = @("backend-agent", "frontend-agent", "dba-agent", "devops-agent", "doc-agent")

if (-not [string]::IsNullOrEmpty($teammateName)) {
    if ($codingAgents -contains $teammateName) {
        $isCodingTask = $true
    }
}

# 策略B: task_subject 包含编码关键词
if (-not $isCodingTask -and -not [string]::IsNullOrEmpty($taskSubject)) {
    $lowerSubject = $taskSubject.ToLower()
    
    $codingKeywords = @(
        "implement", "fix", "refactor", "migrate", "migration",
        "backend", "frontend", "dba", "database", "schema",
        "table", "column", "index", "flyway", "sql", "ddl",
        "bugfix", "bug fix", "hotfix", "patch",
        "controller", "service", "repository", "api", "endpoint",
        "component", "page", "hook", "store", "reducer",
        "docs", "documentation", "readme", "changelog", "api doc"
    )
    
    foreach ($keyword in $codingKeywords) {
        if ($lowerSubject -match $keyword) {
            $isCodingTask = $true
            break
        }
    }
}

# 如果不是编码任务，直接允许完成
if (-not $isCodingTask) {
    exit 0
}

# 是编码任务，检查Git分支
try {
    $currentBranch = git rev-parse --abbrev-ref HEAD 2>$null
    
    if ([string]::IsNullOrEmpty($currentBranch)) {
        Write-Host "ERROR: Could not determine current git branch." -ForegroundColor Red
        Write-Host "Ensure the workspace is inside a git repository." -ForegroundColor Red
        exit 2
    }
    
    # 检查是否在main或master
    if ($currentBranch -eq "HEAD") {
        Write-Host "ERROR: Repository is in detached HEAD state." -ForegroundColor Red
        Write-Host "Coding tasks must be completed on a named feature branch." -ForegroundColor Red
        Write-Host "" -ForegroundColor Red
        Write-Host "Solution: git checkout -b feature/TASK-{ID}" -ForegroundColor Yellow
        exit 2
    }
    
    if ($currentBranch -eq "main" -or $currentBranch -eq "master") {
        Write-Host "ERROR: Task '$taskSubject' ($teammateName) is completing on branch '$currentBranch'." -ForegroundColor Red
        Write-Host "Direct commits to main/master are prohibited for all coding and documentation tasks." -ForegroundColor Red
        Write-Host "" -ForegroundColor Red
        Write-Host "Solution:" -ForegroundColor Yellow
        Write-Host "  git checkout -b feature/TASK-{ID}" -ForegroundColor Yellow
        Write-Host "  git cherry-pick <your commits>   # if commits already exist on main" -ForegroundColor Yellow
        exit 2
    }
}
catch {
    # Git命令失败，允许完成（可能Git不可用）
    exit 0
}

# 所有检查通过，允许完成
exit 0

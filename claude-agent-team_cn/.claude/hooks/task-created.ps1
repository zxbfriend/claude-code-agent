# TaskCreated Hook - PowerShell Version for Windows
# 运行于任务创建时，验证task_subject和task_id
# 退出码: 0 = 允许创建, 2 = 拒绝创建

param(
    [Parameter(ValueFromPipeline = $true)]
    [string]$JsonInput = ""
)

# 如果没有JSON输入，尝试从stdin读取
if ([string]::IsNullOrEmpty($JsonInput)) {
    $JsonInput = [System.Console]::In.ReadToEnd()
}

# 验证JSON是否为空
if ([string]::IsNullOrEmpty($JsonInput.Trim())) {
    Write-Error "No JSON input received"
    exit 0
}

try {
    # 解析JSON
    $data = $JsonInput | ConvertFrom-Json
}
catch {
    Write-Error "Failed to parse JSON input: $_"
    exit 0
}

# 初始化错误列表
$errors = @()

# 验证 task_subject 非空
$taskSubject = $data.task_subject
if ([string]::IsNullOrEmpty($taskSubject) -or [string]::IsNullOrWhiteSpace($taskSubject)) {
    $errors += "'task_subject' is empty — every task must have a non-empty subject/title."
}

# 验证 task_id 存在
$taskId = $data.task_id
if ([string]::IsNullOrEmpty($taskId) -or [string]::IsNullOrWhiteSpace($taskId)) {
    $errors += "'task_id' is missing — this may indicate a hook integration issue."
}

# 如果有错误，输出并拒绝创建
if ($errors.Count -gt 0) {
    Write-Host "Task creation validation failed:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host $error -ForegroundColor Red
    }
    exit 2
}

# 验证通过
exit 0

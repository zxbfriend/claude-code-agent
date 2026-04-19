## Handoff
- task_id: T-YYYYMMDD-001
- from_role: ProjectManager / RequirementsAnalyst / FrontendDeveloper / BackendDeveloper / CodeReviewer / QAEngineer
- to_role: RequirementsAnalyst / FrontendDeveloper / BackendDeveloper / CodeReviewer / QAEngineer / ProjectManager
- status: in_progress
- summary: one-line handoff summary
- scope: current work scope
- changes:
  - key change 1
  - key change 2
- evidence:
  - D:\Github\openclaw\dev-agents\docs\T-YYYYMMDD-001-requirements.md
  - D:\Github\openclaw\dev-agents\reports\T-YYYYMMDD-001-frontend-developer-report.md
- risks:
  - risk 1
  - risk 2
- next_action: next action for receiver
- owner: current owner
- updated_at: YYYY-MM-DD HH:mm Asia/Shanghai

## Blocked Info
- block_reason: required when `status=blocked`
- required_input: unblock dependency
- impact: scope/time/quality impact
- eta_after_unblock: expected finish time after unblock

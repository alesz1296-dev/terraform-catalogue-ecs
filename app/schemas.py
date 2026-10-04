from pydantic import BaseModel


class Module(BaseModel):
    module_id: str
    name: str
    project: str
    iac_tool: str
    category: str
    difficulty: str
    aws_services: list[str]
    service_features: list[str]
    use_cases: list[str]
    description: str
    status: str


class ModuleListResponse(BaseModel):
    count: int
    modules: list[Module]


class ModuleResponse(BaseModel):
    module: Module


class HealthResponse(BaseModel):
    status: str


class ServiceInfoResponse(BaseModel):
    service: str
    version: str
    runtime: str

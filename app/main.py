import os

from fastapi import FastAPI, HTTPException, Query

from app.data import MODULES
from app.schemas import (
    HealthResponse,
    ModuleListResponse,
    ModuleResponse,
    ServiceInfoResponse,
)


APP_VERSION = os.getenv("APP_VERSION", "1.0.0")

app = FastAPI(
    title="Terraform Catalogue Container API",
    version=APP_VERSION,
    description="Containerized Terraform Catalogue API for ECS Fargate.",
)


@app.get("/", response_model=ServiceInfoResponse)
def root():
    return {
        "service": "Terraform Catalogue Container API",
        "version": APP_VERSION,
        "runtime": "FastAPI on ECS Fargate",
    }


@app.get("/health", response_model=HealthResponse)
def health():
    return {
        "status": "healthy",
    }


@app.get("/modules", response_model=ModuleListResponse)
def list_modules(
    category: str | None = Query(default=None),
    difficulty: str | None = Query(default=None),
    service: str | None = Query(default=None),
):
    filtered_modules = MODULES

    if category:
        filtered_modules = [
            module
            for module in filtered_modules
            if module["category"].lower() == category.lower()
        ]

    if difficulty:
        filtered_modules = [
            module
            for module in filtered_modules
            if module["difficulty"].lower() == difficulty.lower()
        ]

    if service:
        filtered_modules = [
            module
            for module in filtered_modules
            if service.lower() in [aws_service.lower() for aws_service in module["aws_services"]]
        ]

    return {
        "count": len(filtered_modules),
        "modules": filtered_modules,
    }


@app.get("/modules/{module_id}", response_model=ModuleResponse)
def get_module(module_id: str):
    for module in MODULES:
        if module["module_id"] == module_id:
            return {
                "module": module,
            }

    raise HTTPException(
        status_code=404,
        detail={
            "code": "MODULE_NOT_FOUND",
            "message": "Module not found.",
        },
    )

from fastapi import FastAPI

app = FastAPI(
    title="FairVerse AI Core",
    description="Open, Fair, Personal AI for Every Citizen",
    version="0.1.0"
)

@app.get("/")
def root():
    return {"status": "FairVerse AI Core is alive"}

@app.get("/health")
def health():
    return {
        "service": "fairverse-backend",
        "status": "ok"
    }
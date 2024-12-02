import pytest
from calculator-app import app  

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_home(client):
    response = client.get("/")
    assert response.status_code == 200

def test_calculate(client):
    response = client.post("/calculate", json={"expression": "2+2"})
    assert response.status_code == 200
    assert response.get_json()["result"] == 4

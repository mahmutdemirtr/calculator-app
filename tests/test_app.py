import pytest
from app import app

# Flask test client'ını kullanmak için
@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

# Homepage test fonksiyonu
def test_homepage(client):
    response = client.get('/')
    assert b'<!DOCTYPE html>' in response.data  # HTML içeriği kontrolü
    assert b'<title>Flask Hesap Makinesi</title>' in response.data  # Başlık kontrolü

# Calculator test fonksiyonu
def test_calculate(client):
    response = client.post('/calculate', json={'expression': '2 + 2'})
    data = response.get_json()
    assert data['result'] == 4

    response = client.post('/calculate', json={'expression': 'invalid'})
    data = response.get_json()
    assert 'error' in data

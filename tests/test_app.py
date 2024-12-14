import pytest
from app import app  # Flask uygulamanızı import ettik

# Flask test client'ını sağlayan bir fixture
@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

# Test: Ana sayfaya gidip doğru mesajı alıp almadığımızı kontrol edelim
def test_homepage(client):
    response = client.get('/')
    assert response.data == b"Welcome to the Calculator App!"  # Geri dönen mesajı kontrol et

# Test: Basit bir hesaplama işlemi yapalım (örneğin, 3 + 5)
def test_calculate(client):
    response = client.post('/calculate', json={'expression': '3+5'})
    assert response.status_code == 200  # 200 OK döndürmesini bekliyoruz
    assert response.json['result'] == 8  # Hesaplama sonucunun doğru olması gerek

# Test: Hatalı bir hesaplama ile hata mesajı döndüğünü kontrol edelim
def test_calculate_invalid_expression(client):
    response = client.post('/calculate', json={'expression': '3/0'})
    assert response.status_code == 400  # Hata kodu döndürmesini bekliyoruz
    assert 'error' in response.json  # JSON yanıtında 'error' anahtarının bulunması gerek

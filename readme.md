```markdown
# Automação de Testes de API CRUD com Robot Framework

Projeto de automação para testar operações CRUD em uma API REST.  
Inclui criação, leitura, atualização e exclusão de recursos, além de geração de relatórios em HTML e CSV.

---

## 📋 Pré-requisitos

- **Python 3.8 ou superior**  
  Verifique a versão:
  ```bash
  python --version
  ```

- **Acesso ao terminal (Linux/Mac) ou PowerShell (Windows)**

---

## 🛠️ Instalação Passo a Passo

### 1. Atualize o gerenciador de pacotes `pip`
```bash
python.exe -m pip install --upgrade pip
```

### 2. Clone o repositório
```bash
git clone https://github.com/Rubejunior/Crudcrud-robotFramework.git
cd projeto-api-tests
```

### 3. Crie um ambiente virtual (recomendado)
```bash
python -m venv venv
```

#### Ative o ambiente virtual:
- **Windows (PowerShell):**
  ```bash
  .\venv\Scripts\Activate
  ```
- **Linux/Mac:**
  ```bash
  source venv/bin/activate
  ```

### 4. Instale as dependências
```bash
pip install robotframework robotframework-requests
```

#### Verifique as instalações:
```bash
pip list | grep "robotframework
```
Saída esperada:
```

robotframework    6.1.1
robotframework-requests 0.9.4
```

---

## ⚙️ Configuração

### 1. Configure a API
Edite o arquivo `resources/variables.py` com seu token do CRUDCrud:
```python
BASE_URL = "https://crudcrud.com/api/SEU_TOKEN_AQUI"
```

### 2. Estrutura do Projeto
```
📦 projeto-api-tests
├── 📂 Results           # Relatórios e logs
├── 📂 resources
│   ├── 📜 common.resource  # Keywords compartilhadas
│   └── 📜 variables.py     # Configurações da API
├── 📂 tests
│   └── 📜 crud_tests.robot # Casos de teste
└── 📜 README.md            # Este guia
```

---

## 🚀 Execução dos Testes

### 1. Execute todos os testes
```bash
robot -d Results tests/crud_tests.robot
```

### 2. Execute um teste específico
```bash
robot -d Results -t "Create Unicorn" tests/crud_tests.robot
```

### 3. Acesse os relatórios
Abra o arquivo `Results/report.html` em seu navegador:
```bash
start Results/report.html  # Windows
xdg-open Results/report.html  # Linux
open Results/report.html  # Mac
```

---

## 📊 Saída Esperada

### Relatório HTML
![Relatório HTML] 

### Planilha de Erros (Excel)
![Planilha de Erros](https://i.imgur.com/3XnQ7Wp.png)

---

## 🐛 Troubleshooting

**Erro:** `HTTPError: 404 Client Error`  
**Solução:**  
- Verifique se o token no `variables.py` está correto
- Garanta que o serviço [CRUDCrud](https://crudcrud.com/) está online

**Erro:** `ModuleNotFoundError: No module named 'openpyxl'`  
**Solução:**  
- Reinstale as dependências:
  ```bash
  pip uninstall openpyxl robotframework-requests robotframework
  pip install robotframework robotframework-requests openpyxl
  ```

---

## 📝 Licença
Este projeto é open-source sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE).

```

---
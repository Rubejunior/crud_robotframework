*** Settings ***
Library    RequestsLibrary    # Biblioteca para realizar chamadas HTTP
Library    Collections        # Biblioteca para manipulação de coleções de dados
Resource    ../resources/common.resource    # Arquivo de recursos com palavras-chave e funções comuns
Variables    ../resources/variables.py       # Arquivo de variáveis com dados de configuração e dados de teste

*** Variables ***
${UNICORN_ID}    ${EMPTY}  # Variável para armazenar o ID gerado após a criação do recurso

*** Test Cases ***

# Teste de criação de um recurso (POST)
Create Unicorn
    Create Session    crud    ${BASE_URL}    verify=true    # Inicializa uma sessão para chamadas HTTP
    ${response} =    POST On Session    crud    ${RESOURCE}    json=${UNICORN_DATA}    # Envia uma requisição POST com os dados do unicórnio
    Should Be Equal As Numbers    ${response.status_code}    201    # Verifica se o status code é 201 (Created)
    
    # Verifica se o campo _id existe na resposta
    ${response_json} =    Set Variable    ${response.json()}
    Should Be True    '_id' in ${response_json}
    
    ${unicorn_id} =    Set Variable    ${response_json['_id']}    # Extrai o ID gerado pelo recurso
    Set Suite Variable    ${UNICORN_ID}    ${unicorn_id}    # Armazena o ID para uso em testes subsequentes
    Log    \n🦄 CRIADO: ${UNICORN_DATA} | ID: ${UNICORN_ID}    console=True    # Registra o resultado no console
    Registrar Resultado na Planilha    ${TEST_NAME}    status=PASS    # Registra o resultado na planilha

# Teste de leitura de um recurso (GET)
Read Unicorn
    ${response} =    GET On Session    crud    ${RESOURCE}/${UNICORN_ID}    # Envia uma requisição GET para obter o recurso pelo ID
    Should Be Equal As Numbers    ${response.status_code}    200    # Verifica se o status code é 200 (OK)
    
    ${response_data} =    Set Variable    ${response.json()}    # Armazena os dados retornados pela API
    
    # Verifica se todos os campos esperados estão presentes
    Should Be True    'name' in ${response_data}
    Should Be True    'age' in ${response_data}
    Should Be True    'colour' in ${response_data}
    
    Log    \n🔍 DADOS ENCONTRADOS: ${response_data}    console=True    # Registra os dados no console
    Should Be Equal As Strings    ${response_data['name']}    ${UNICORN_DATA['name']}    # Verifica se o nome do recurso corresponde ao esperado
    Should Be Equal As Numbers    ${response_data['age']}    ${UNICORN_DATA['age']}    # Verifica se a idade corresponde
    Should Be Equal As Strings    ${response_data['colour']}    ${UNICORN_DATA['colour']}    # Verifica se a cor corresponde
    Registrar Resultado na Planilha    ${TEST_NAME}    status=PASS    # Registra o resultado na planilha

# Teste de atualização de um recurso (PUT)
Update Unicorn
    ${response} =    PUT On Session    crud    ${RESOURCE}/${UNICORN_ID}    json=${UPDATED_UNICORN_DATA}    # Envia uma requisição PUT com os dados atualizados
    Should Be Equal As Numbers    ${response.status_code}    200    # Verifica se o status code é 200 (OK)
    
    ${updated_response} =    GET On Session    crud    ${RESOURCE}/${UNICORN_ID}    # Verifica o recurso atualizado com uma nova requisição GET
    ${response_data} =    Set Variable    ${updated_response.json()}    # Armazena os dados atualizados
    
    # Verifica se todos os campos foram atualizados corretamente
    Should Be Equal As Strings    ${response_data['name']}    ${UPDATED_UNICORN_DATA['name']}
    Should Be Equal As Numbers    ${response_data['age']}    ${UPDATED_UNICORN_DATA['age']}
    Should Be Equal As Strings    ${response_data['colour']}    ${UPDATED_UNICORN_DATA['colour']}
    
    Log    \n🔄 ATUALIZADO: De '${UNICORN_DATA['name']}' para '${UPDATED_UNICORN_DATA['name']}'    console=True    # Registra a atualização no console
    Registrar Resultado na Planilha    ${TEST_NAME}    status=PASS    # Registra o resultado na planilha

# Teste de exclusão de um recurso (DELETE)
Delete Unicorn
    ${response} =    DELETE On Session    crud    ${RESOURCE}/${UNICORN_ID}    # Envia uma requisição DELETE para remover o recurso
    Should Be Equal As Numbers    ${response.status_code}    200    # Verifica se o status code é 200 (OK)
    Log    \n🗑️ DELETADO: ID ${UNICORN_ID} - Dados removidos com sucesso!    console=True    # Registra a exclusão no console
    
    # Verifica se o recurso foi removido com sucesso
    ${response} =    GET On Session    crud    ${RESOURCE}/${UNICORN_ID}    expected_status=404    # Tenta acessar o recurso novamente, esperando status 404 (Not Found)
    Should Be Equal As Numbers    ${response.status_code}    404    # Verifica se o status code é 404 (Not Found)
    Registrar Resultado na Planilha    ${TEST_NAME}    status=PASS    # Registra o resultado na planilha
    [Teardown]    Delete All Sessions    # Limpa todas as sessões após o teste
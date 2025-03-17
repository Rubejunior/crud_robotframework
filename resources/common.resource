# tests/crud_tests.robot

*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    DateTime
Library    OperatingSystem
Resource    ../resources/common.resource
Variables    ../resources/variables.py

*** Keywords ***
Create Unicorn
    Create Session    alias=session    url=${BASE_URL}
    ${response}=    Post On Session    session    ${RESOURCE}    ${UNICORN_DATA}
    Should Be Equal As Strings    ${response.status_code}    201
    ${json_response}=    Evaluate    json.loads('''${response.content}''')    json
    Should Contain Key    ${json_response}    _id
    ${UNICORN_DATA}=    Get From Dictionary    ${json_response}    _id
    Set Suite Variable    ${UNICORN_DATA}

Read Unicorn
    ${response}=    Get On Session    session    ${RESOURCE}/${UNICORN_DATA}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_response}=    Evaluate    json.loads('''${response.content}''')    json
    Should Contain Key    ${json_response}    _id
    Should Be Equal As Strings    ${json_response["_id"]}    ${UNICORN_DATA}
    Should Be Equal As Strings    ${json_response["name"]}    ${UNICORN_DATA["name"]}
    Should Be Equal As Strings    ${json_response["age"]}    ${UNICORN_DATA["age"]}
    Should Be Equal As Strings    ${json_response["colour"]}    ${UNICORN_DATA["colour"]}

Update Unicorn
    ${response}=    Put On Session    session    ${RESOURCE}/${UNICORN_DATA}    ${UPDATED_UNICORN_DATA}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_response}=    Evaluate    json.loads('''${response.content}''')    json
    Should Contain Key    ${json_response}    _id
    Should Be Equal As Strings    ${json_response["_id"]}    ${UNICORN_DATA}
    Should Be Equal As Strings    ${json_response["name"]}    ${UPDATED_UNICORN_DATA["name"]}
    Should Be Equal As Strings    ${json_response["age"]}    ${UPDATED_UNICORN_DATA["age"]}
    Should Be Equal As Strings    ${json_response["colour"]}    ${UPDATED_UNICORN_DATA["colour"]}

Delete Unicorn
    ${response}=    Delete On Session    session    ${RESOURCE}/${UNICORN_DATA}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response}=    Get On Session    session    ${RESOURCE}/${UNICORN_DATA}
    Should Be Equal As Strings    ${response.status_code}    404


Registrar Resultado na Planilha
    [Arguments]    ${test_name}    ${status}=PASS    ${error_code}=N/A    ${error_message}=Nenhum erro encontrado
    ${timestamp}=    Get Current Date    result_format=%d/%m/%Y %H:%M:%S
    ${planilha}=    Set Variable    ${EXECDIR}${/}Results${/}relatorio_erros.csv
    
    # Depuração: Exibe o caminho da planilha
    Log    Tentando salvar resultado em: ${planilha}    console=True
    
    ${dados}=    Create List    ${timestamp}    ${test_name}    ${status}    ${error_code}    ${error_message}
    
    # Verifica se a planilha existe
    ${planilha_existe}=    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${planilha}
    
    # Cria planilha se não existir
    Run Keyword If    not ${planilha_existe}    Criar Planilha Base    ${planilha}
    
    # Converte a lista em uma linha CSV
    ${linha_csv}=    Convert List To CSV Line    ${dados}
    
    # Adiciona registro ao arquivo CSV
    Append To File    ${planilha}    ${linha_csv}\n    encoding=UTF-8
    
    # Depuração: Confirmação de salvamento
    Log    Resultado salvo com sucesso!    console=True

Criar Planilha Base
    [Arguments]    ${caminho}
    ${headers}=    Create List    Data/Hora    Teste    Status    Código Erro    Mensagem
    ${cabecalho_csv}=    Convert List To CSV Line    ${headers}
    Create File    ${caminho}    ${cabecalho_csv}\n    encoding=UTF-8

Convert List To CSV Line
    [Arguments]    ${lista}
    ${linha_csv}=    Set Variable    ${EMPTY}
    FOR    ${item}    IN    @{lista}
        ${linha_csv}=    Set Variable    ${linha_csv}${item},
    END
    ${linha_csv}=    Evaluate    '${linha_csv}'.rstrip(',')  # Remove a última vírgula
    RETURN    ${linha_csv}
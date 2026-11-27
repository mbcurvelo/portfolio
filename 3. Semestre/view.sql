USE LMFVistorias;
GO

/* ====================================================== 
   VIEW 1: vw_Relatorio_Geral
   Descrição: Lista imóveis, proprietários e inquilinos
   ====================================================== */
CREATE VIEW vw_Relatorio_Geral AS
SELECT 
    I.cod_imovel,
    I.endereco_completo AS [Endereço do Imóvel],
    L.nome AS [Proprietário],
    L.telefone_contato AS [Tel. Proprietário],
    T.nome AS [Inquilino],
    T.telefone_contato AS [Tel. Inquilino]
FROM Imovel I
INNER JOIN Imovel_Locador_Tem ILT ON I.cod_imovel = ILT.fk_Imovel_cod_imovel
INNER JOIN Locador L ON ILT.fk_Locador_cpf = L.cpf
INNER JOIN Locatario_Imovel_Tem LIT ON I.cod_imovel = LIT.fk_Imovel_cod_imovel
INNER JOIN Locatario T ON LIT.fk_Locatario_cpf = T.cpf;
GO

/* ====================================================== 
   VIEW 2: vw_Avarias_Completas
   Descrição: Detalha avarias e classifica se é estrutural ou não
   ====================================================== */
CREATE VIEW vw_Avarias_Completas AS
SELECT 
    A.cod_imovel,
    A.endereco AS [Local da Avaria],
    A.avaria AS [Título],
    A.descricao AS [Detalhes],
    -- Lógica para pegar a descrição do tipo correto
    COALESCE(TE.descricao, TNE.descricao) AS [Tipo de Dano],
    -- Lógica para criar a categoria visualmente
    CASE 
        WHEN TE.descricao IS NOT NULL THEN 'Estrutural'
        ELSE 'Não Estrutural'
    END AS [Categoria]
FROM Avaria A
LEFT JOIN Avaria_TipoEstrutural_Possui ATEP ON A.cod_imovel = ATEP.fk_Avaria_cod_imovel
LEFT JOIN Tipo_Estrutural TE ON ATEP.fk_Tipo_Estrutural_codigo = TE.codigo
LEFT JOIN Avaria_Tipo_N_Estrutural_Possui ATNEP ON A.cod_imovel = ATNEP.fk_Avaria_cod_imovel
LEFT JOIN Tipo_N_Estrutural TNE ON ATNEP.fk_Tipo_N_Estrutural_codigo = TNE.codigo;
GO

/* ====================================================== 
   VIEW 3: vw_Historico_Reparos
   Descrição: Mostra apenas o que já foi reparado pelo locador
   ====================================================== */
CREATE VIEW vw_Historico_Reparos AS
SELECT 
    L.nome AS [Quem Reparou],
    A.avaria AS [Problema],
    A.endereco AS [Local],
    A.descricao AS [Descrição]
FROM Locador_Avaria_Repara LAR
INNER JOIN Locador L ON LAR.fk_Locador_cpf = L.cpf
INNER JOIN Avaria A ON LAR.fk_Avaria_cod_imovel = A.cod_imovel;
GO
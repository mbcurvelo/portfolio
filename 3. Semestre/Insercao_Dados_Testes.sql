USE LMFVistorias;
GO

/* ====================================================== 
   INSERINDO DADOS 
   ====================================================== */

-- 1. Tipos de Avarias
INSERT INTO Tipo_Estrutural (codigo, descricao) VALUES
(1, 'Rachadura na fundação'), (2, 'Infiltração no teto'), (3, 'Desabamento parcial');

INSERT INTO Tipo_N_Estrutural (codigo, descricao) VALUES
(1, 'Pintura descascada'), (2, 'Vidro quebrado'), (3, 'Móvel danificado');

-- 2. Locatários e Locadores
INSERT INTO Locador (cpf, nome, telefone_contato, cod_imovel) VALUES
('111.111.111-11', 'João Proprietário', '(11) 91111-1111', 101),
('222.222.222-22', 'Maria Dona', '(21) 92222-2222', 102);

INSERT INTO Locatario (cpf, nome, telefone_contato, cod_imovel) VALUES
('333.333.333-33', 'Carlos Inquilino', '(11) 93333-3333', 101),
('444.444.444-44', 'Ana Locatária', '(21) 94444-4444', 102);

-- 3. Avarias
INSERT INTO Avaria (cod_imovel, locador, locatario, endereco, avaria, descricao) VALUES
(101, 'João Proprietário', 'Carlos Inquilino', 'Rua das Flores, 123', 'Infiltração Sala', 'Mancha de água no teto da sala de estar'),
(102, 'Maria Dona', 'Ana Locatária', 'Av. Paulista, 1000', 'Janela Quebrada', 'Vidro da varanda quebrado');

-- 4. Imóveis
INSERT INTO Imovel (cod_imovel, proprietario, endereco_completo, possivel_avaria, fk_Avaria_cod_imovel) VALUES
(101, 'João Proprietário', 'Rua das Flores, 123', 'Sim, no teto', 101),
(102, 'Maria Dona', 'Av. Paulista, 1000', 'Sim, na varanda', 102);

-- 5. Relacionamentos
INSERT INTO Imovel_Locador_Tem (cod_IL, fk_Imovel_cod_imovel, fk_Locador_cpf) VALUES
(1, 101, '111.111.111-11'), (2, 102, '222.222.222-22');

INSERT INTO Locatario_Imovel_Tem (cod_LI, fk_Imovel_cod_imovel, fk_Locatario_cpf) VALUES
(1, 101, '333.333.333-33'), (2, 102, '444.444.444-44');

INSERT INTO Avaria_TipoEstrutural_Possui (cod_Avaria_E, fk_Avaria_cod_imovel, fk_Tipo_Estrutural_codigo) VALUES
(1, 101, 2);

INSERT INTO Avaria_Tipo_N_Estrutural_Possui (cod_Avaria_NE, fk_Avaria_cod_imovel, fk_Tipo_N_Estrutural_codigo) VALUES
(1, 102, 2);

INSERT INTO Avaria_Locatario_Relata (cod_AL, fk_Locatario_cpf, fk_Avaria_cod_imovel) VALUES
(1, '333.333.333-33', 101), (2, '444.444.444-44', 102);

INSERT INTO Locador_Avaria_Repara (cod_LA, fk_Locador_cpf, fk_Avaria_cod_imovel) VALUES
(1, '222.222.222-22', 102);
GO


/* ====================================================== 
  VISUALIZANDO OS DADOS INSERIDOS 
   ====================================================== */
SELECT 
    I.endereco_completo AS [Endereço do Imóvel],
    L.nome AS [Nome do Proprietário],
    T.nome AS [Nome do Inquilino],
    L.telefone_contato AS [Tel. Proprietário],
    T.telefone_contato AS [Tel. Inquilino]
FROM Imovel I
-- Ligação com o Locador (Proprietário)
INNER JOIN Imovel_Locador_Tem ILT ON I.cod_imovel = ILT.fk_Imovel_cod_imovel
INNER JOIN Locador L ON ILT.fk_Locador_cpf = L.cpf
-- Ligação com o Locatário (Inquilino)
INNER JOIN Locatario_Imovel_Tem LIT ON I.cod_imovel = LIT.fk_Imovel_cod_imovel
INNER JOIN Locatario T ON LIT.fk_Locatario_cpf = T.cpf;


/* ====================================================== 
  AVARIAS DETALHADAS 
   ====================================================== */
   SELECT 
    A.endereco AS [Local da Avaria],
    A.avaria AS [Título do Problema],
    A.descricao AS [Descrição Detalhada],
    -- Tenta pegar descrição estrutural, se não existir, pega a não estrutural
    COALESCE(TE.descricao, TNE.descricao) AS [Tipo de Dano],
    CASE 
        WHEN TE.descricao IS NOT NULL THEN 'Estrutural'
        ELSE 'Não Estrutural'
    END AS [Categoria]
FROM Avaria A
-- Tenta buscar vínculo com Tipo Estrutural
LEFT JOIN Avaria_TipoEstrutural_Possui ATEP ON A.cod_imovel = ATEP.fk_Avaria_cod_imovel
LEFT JOIN Tipo_Estrutural TE ON ATEP.fk_Tipo_Estrutural_codigo = TE.codigo
-- Tenta buscar vínculo com Tipo Não Estrutural
LEFT JOIN Avaria_Tipo_N_Estrutural_Possui ATNEP ON A.cod_imovel = ATNEP.fk_Avaria_cod_imovel
LEFT JOIN Tipo_N_Estrutural TNE ON ATNEP.fk_Tipo_N_Estrutural_codigo = TNE.codigo;


/* ====================================================== 
  DONO E ONDE MORA
   ====================================================== */
   SELECT 
    I.endereco_completo AS [Endereço do Imóvel],
    L.nome AS [Nome do Proprietário],
    T.nome AS [Nome do Inquilino],
    L.telefone_contato AS [Tel. Proprietário],
    T.telefone_contato AS [Tel. Inquilino]
FROM Imovel I
-- Ligação com o Locador (Proprietário)
INNER JOIN Imovel_Locador_Tem ILT ON I.cod_imovel = ILT.fk_Imovel_cod_imovel
INNER JOIN Locador L ON ILT.fk_Locador_cpf = L.cpf
-- Ligação com o Locatário (Inquilino)
INNER JOIN Locatario_Imovel_Tem LIT ON I.cod_imovel = LIT.fk_Imovel_cod_imovel
INNER JOIN Locatario T ON LIT.fk_Locatario_cpf = T.cpf;


/* ====================================================== 
  CONSERTOS
   ====================================================== */
   SELECT 
    L.nome AS [Responsável pelo Reparo],
    A.avaria AS [Avaria Consertada],
    A.endereco AS [Local],
    A.descricao AS [O que foi feito]
FROM Locador_Avaria_Repara LAR
INNER JOIN Locador L ON LAR.fk_Locador_cpf = L.cpf
INNER JOIN Avaria A ON LAR.fk_Avaria_cod_imovel = A.cod_imovel;




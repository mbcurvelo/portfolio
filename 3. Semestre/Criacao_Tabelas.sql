CREATE DATABASE LMFVistorias;
GO

USE LMFVistorias;
GO

/* ====================================================== 
   1. CRIAÇÃO DAS TABELAS 
   ====================================================== */

-- Tabela: Locador
CREATE TABLE Locador (
    cpf VARCHAR(14) NOT NULL,
    nome VARCHAR(50),
    telefone_contato VARCHAR(14),
    cod_imovel INT, -- Campo informativo conforme diagrama
    CONSTRAINT PK_Locador PRIMARY KEY (cpf)
);
GO

-- Tabela: Locatario
CREATE TABLE Locatario (
    cpf VARCHAR(14) NOT NULL,
    nome VARCHAR(50),
    telefone_contato VARCHAR(14),
    cod_imovel INT, -- Campo informativo conforme diagrama
    CONSTRAINT PK_Locatario PRIMARY KEY (cpf)
);
GO

-- Tabela: Tipo_Estrutural
CREATE TABLE Tipo_Estrutural (
    codigo INT NOT NULL,
    descricao VARCHAR(255),
    CONSTRAINT PK_Tipo_Estrutural PRIMARY KEY (codigo)
);
GO

-- Tabela: Tipo_N_Estrutural
CREATE TABLE Tipo_N_Estrutural (
    codigo INT NOT NULL,
    descricao VARCHAR(255),
    CONSTRAINT PK_Tipo_N_Estrutural PRIMARY KEY (codigo)
);
GO

-- Tabela: Avaria
-- Nota: O diagrama usa cod_imovel como PK desta tabela
CREATE TABLE Avaria (
    cod_imovel INT NOT NULL, 
    locador VARCHAR(50),
    locatario VARCHAR(50),
    endereco VARCHAR(120),
    avaria VARCHAR(255),
    descricao VARCHAR(255),
    CONSTRAINT PK_Avaria PRIMARY KEY (cod_imovel)
);
GO

-- Tabela: Imovel
CREATE TABLE Imovel (
    cod_imovel INT NOT NULL,
    proprietario VARCHAR(50),
    endereco_completo VARCHAR(50),
    possivel_avaria VARCHAR(255),
    fk_Avaria_cod_imovel INT,
    CONSTRAINT PK_Imovel PRIMARY KEY (cod_imovel)
);
GO

/* ====================================================== 
   2. TABELAS ASSOCIATIVAS (RELACIONAMENTOS)
   ====================================================== */

-- Tabela: Imovel_Locador_Tem
CREATE TABLE Imovel_Locador_Tem (
    cod_IL INT NOT NULL,
    fk_Imovel_cod_imovel INT NOT NULL,
    fk_Locador_cpf VARCHAR(14) NOT NULL,
    CONSTRAINT PK_Imovel_Locador_Tem PRIMARY KEY (cod_IL)
);
GO

-- Tabela: Locatario_Imovel_Tem
CREATE TABLE Locatario_Imovel_Tem (
    cod_LI INT NOT NULL,
    fk_Imovel_cod_imovel INT NOT NULL,
    fk_Locatario_cpf VARCHAR(14) NOT NULL,
    CONSTRAINT PK_Locatario_Imovel_Tem PRIMARY KEY (cod_LI)
);
GO

-- Tabela: Locador_Avaria_Repara
CREATE TABLE Locador_Avaria_Repara (
    cod_LA INT NOT NULL,
    fk_Locador_cpf VARCHAR(14) NOT NULL,
    fk_Avaria_cod_imovel INT NOT NULL,
    CONSTRAINT PK_Locador_Avaria_Repara PRIMARY KEY (cod_LA)
);
GO

-- Tabela: Avaria_Locatario_Relata
CREATE TABLE Avaria_Locatario_Relata (
    cod_AL INT NOT NULL,
    fk_Locatario_cpf VARCHAR(14) NOT NULL,
    fk_Avaria_cod_imovel INT NOT NULL,
    CONSTRAINT PK_Avaria_Locatario_Relata PRIMARY KEY (cod_AL)
);
GO

-- Tabela: Avaria_TipoEstrutural_Possui
CREATE TABLE Avaria_TipoEstrutural_Possui (
    cod_Avaria_E INT NOT NULL,
    fk_Avaria_cod_imovel INT NOT NULL,
    fk_Tipo_Estrutural_codigo INT NOT NULL,
    CONSTRAINT PK_Avaria_TipoEstrutural_Possui PRIMARY KEY (cod_Avaria_E)
);
GO

-- Tabela: Avaria_Tipo_N_Estrutural_Possui
CREATE TABLE Avaria_Tipo_N_Estrutural_Possui (
    cod_Avaria_NE INT NOT NULL,
    fk_Avaria_cod_imovel INT NOT NULL,
    fk_Tipo_N_Estrutural_codigo INT NOT NULL,
    CONSTRAINT PK_Avaria_Tipo_N_Estrutural_Possui PRIMARY KEY (cod_Avaria_NE)
);
GO

/* ====================================================== 
   3. CRIAÇÃO DAS CHAVES ESTRANGEIRAS (CONSTRAINTS)
   ====================================================== */

-- FKs na Tabela Imovel
-- Nota: Baseado no diagrama, Imovel aponta para Avaria.
ALTER TABLE Imovel
ADD CONSTRAINT FK_Imovel_Avaria
    FOREIGN KEY (fk_Avaria_cod_imovel)
    REFERENCES Avaria (cod_imovel);
GO

-- FKs na Tabela Imovel_Locador_Tem
ALTER TABLE Imovel_Locador_Tem
ADD CONSTRAINT FK_ILT_Imovel
    FOREIGN KEY (fk_Imovel_cod_imovel)
    REFERENCES Imovel (cod_imovel),
    CONSTRAINT FK_ILT_Locador
    FOREIGN KEY (fk_Locador_cpf)
    REFERENCES Locador (cpf);
GO

-- FKs na Tabela Locatario_Imovel_Tem
ALTER TABLE Locatario_Imovel_Tem
ADD CONSTRAINT FK_LIT_Imovel
    FOREIGN KEY (fk_Imovel_cod_imovel)
    REFERENCES Imovel (cod_imovel),
    CONSTRAINT FK_LIT_Locatario
    FOREIGN KEY (fk_Locatario_cpf)
    REFERENCES Locatario (cpf);
GO

-- FKs na Tabela Locador_Avaria_Repara
ALTER TABLE Locador_Avaria_Repara
ADD CONSTRAINT FK_LAR_Locador
    FOREIGN KEY (fk_Locador_cpf)
    REFERENCES Locador (cpf),
    CONSTRAINT FK_LAR_Avaria
    FOREIGN KEY (fk_Avaria_cod_imovel)
    REFERENCES Avaria (cod_imovel);
GO

-- FKs na Tabela Avaria_Locatario_Relata
ALTER TABLE Avaria_Locatario_Relata
ADD CONSTRAINT FK_ALR_Locatario
    FOREIGN KEY (fk_Locatario_cpf)
    REFERENCES Locatario (cpf),
    CONSTRAINT FK_ALR_Avaria
    FOREIGN KEY (fk_Avaria_cod_imovel)
    REFERENCES Avaria (cod_imovel);
GO

-- FKs na Tabela Avaria_TipoEstrutural_Possui
ALTER TABLE Avaria_TipoEstrutural_Possui
ADD CONSTRAINT FK_ATEP_Avaria
    FOREIGN KEY (fk_Avaria_cod_imovel)
    REFERENCES Avaria (cod_imovel),
    CONSTRAINT FK_ATEP_Tipo
    FOREIGN KEY (fk_Tipo_Estrutural_codigo)
    REFERENCES Tipo_Estrutural (codigo);
GO

-- FKs na Tabela Avaria_Tipo_N_Estrutural_Possui
ALTER TABLE Avaria_Tipo_N_Estrutural_Possui
ADD CONSTRAINT FK_ATNEP_Avaria
    FOREIGN KEY (fk_Avaria_cod_imovel)
    REFERENCES Avaria (cod_imovel),
    CONSTRAINT FK_ATNEP_Tipo
    FOREIGN KEY (fk_Tipo_N_Estrutural_codigo)
    REFERENCES Tipo_N_Estrutural (codigo);
GO


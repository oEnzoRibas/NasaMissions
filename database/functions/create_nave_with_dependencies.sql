CREATE OR REPLACE FUNCTION create_nave_with_dependencies(
    p_nome TEXT,
    p_tipo TEXT,
    p_fabricante TEXT,
    p_ano_construcao INT,
    p_status TEXT,
    p_missoes JSONB DEFAULT NULL, -- Array of mission objects
    p_tripulantes JSONB DEFAULT NULL -- Array of tripulante objects
)
RETURNS INT -- Returns the ID of the newly created nave
AS $$
DECLARE
    v_id_nave INT;
    v_missao JSONB;
    v_tripulante JSONB;
BEGIN
    -- Input Validation: Check if at least one mission or tripulante is provided
    IF (p_missoes IS NULL OR jsonb_array_length(p_missoes) = 0) AND
       (p_tripulantes IS NULL OR jsonb_array_length(p_tripulantes) = 0) THEN
        RAISE EXCEPTION 'A nave deve ser criada com pelo menos uma missão OU um tripulante.' USING ERRCODE = 'P0001', HINT = 'Forneça dados para missoes e/ou tripulantes.';
    END IF;

    -- Insert Nave
    INSERT INTO naves (nome, tipo, fabricante, ano_construcao, status)
    VALUES (p_nome, p_tipo, p_fabricante, p_ano_construcao, p_status)
    RETURNING id_nave INTO v_id_nave;

    -- Insert Missoes if provided
    IF p_missoes IS NOT NULL AND jsonb_array_length(p_missoes) > 0 THEN
        FOR v_missao IN SELECT * FROM jsonb_array_elements(p_missoes)
        LOOP
            INSERT INTO missoes (
                id_nave,
                nome_missao,
                data_lancamento,
                destino,
                duracao_dias,
                resultado,
                descricao
            )
            VALUES (
                v_id_nave,
                v_missao->>'nome_missao',
                (v_missao->>'data_lancamento')::DATE,
                v_missao->>'destino',
                (v_missao->>'duracao_dias')::INT,
                v_missao->>'resultado',
                v_missao->>'descricao'
            );
        END LOOP;
    END IF;

    -- Insert Tripulantes if provided
    IF p_tripulantes IS NOT NULL AND jsonb_array_length(p_tripulantes) > 0 THEN
        FOR v_tripulante IN SELECT * FROM jsonb_array_elements(p_tripulantes)
        LOOP
            INSERT INTO tripulantes (
                id_nave,
                nome_tripulante,
                data_de_nascimento,
                genero,
                nacionalidade,
                competencia,
                data_ingresso,
                status
            )
            VALUES (
                v_id_nave,
                v_tripulante->>'nome_tripulante',
                (v_tripulante->>'data_de_nascimento')::DATE,
                v_tripulante->>'genero',
                v_tripulante->>'nacionalidade',
                v_tripulante->>'competencia',
                (v_tripulante->>'data_ingresso')::DATE,
                v_tripulante->>'status'
            );
        END LOOP;
    END IF;

    RETURN v_id_nave;
END;
$$ LANGUAGE plpgsql;

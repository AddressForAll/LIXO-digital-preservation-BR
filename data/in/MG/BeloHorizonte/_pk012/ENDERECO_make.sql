
-- CSV file of id_origin 5175, pack_id 12, hash 1ce29a555565be5f540ab0c6f93ac55797c368293e0a6bfb479a645a5a23f542

-- GERACAO DA TABELA DE ETL:
SELECT ingest.fdw_generate_getCSV('enderecos','br_pk012');
  --   tmp_orig.fdw_enderecos_br_pk012 was created!+
  --   source: /tmp/pg_io/br_pk012-enderecos.csv 


-- RESUMO DA VOLUMETRIA DO CSV:
SELECT *, n_geom-n_l AS n_perfect  FROM (
  SELECT count(*) n, COUNT(distinct GEOMETRIA) n_geom, count(LETRA_IMOVEL) n_l
  FROM tmp_orig.fdw_enderecos_br_pk012
) t; -- 735894 | 732755 | 137559 | 595196

SELECT array_agg(distinct SIGLA_TIPO_LOGRADOURO) FROM tmp_orig.fdw_enderecos_br_pk012;
--  {ACS,ALA,AVE,BEC,ELP,EST,LRG,PCA,RDP,ROD,RUA,TRE,TRI,TRV,VDP,VDT,VIA}

--------- CLEAN:
DELETE FROM ingest.addr_point WHERE pack_id=12;
---------- ETL E INSERT:
WITH prep AS (
    SELECT 12 AS pack_id,
         SIGLA_TIPO_LOGRADOURO ||
            CASE WHEN SIGLA_TIPO_LOGRADOURO IN ('RUA','VIA') THEN ' ' ELSE '. ' END ||
            NOME_LOGRADOURO AS street_name,
         NUMERO_IMOVEL || COALESCE('-'||LETRA_IMOVEL,'') AS house_number,
         ST_Transform( ST_SetSRID(GEOMETRIA::geometry, 31983), 4326) as geom,
         LETRA_IMOVEL
    FROM tmp_orig.fdw_enderecos_br_pk012
    -- WHERE LETRA_IMOVEL is null -- 579018
), prep_dup_geom AS (  -- Geometrias duplicadas:
   select geom FROM prep GROUP BY 1 HAVING count(*)>1
), prep_dup_addr AS (
   -- Endereços rua_e_numero não-vizinhos duplicados:
   SELECT * FROM (SELECT sthn, round(sqrt(st_area(ST_Envelope(u),true))) as avg_dist, n
   FROM (
     SELECT street_name||house_number as sthn,
            st_union(geom) as u, count(*) n
     FROM prep GROUP BY 1 HAVING count(*)>1
   ) t1 ) t2
   WHERE (n>2 AND avg_dist>500) OR (n=2 AND avg_dist>3000)
)
  INSERT INTO ingest.addr_point (pack_id,vianame,housenum,geom)
    -- Main set of items:
    SELECT pack_id,street_name, house_number, geom
    FROM prep
    WHERE geom NOT IN (select geom FROM prep_dup_geom)
          AND  street_name||house_number NOT IN (SELECT sthn FROM prep_dup_addr)
    UNION
    -- Sample of duplicated geoms:
    SELECT pack_id,street_name, house_number, geom
    FROM prep
    WHERE LETRA_IMOVEL IS NULL AND geom IN  (select geom FROM prep GROUP BY 1 HAVING count(*)>1)
          AND  street_name||house_number NOT IN (SELECT sthn FROM prep_dup_addr)
    UNION
    -- Duplicated address:
    SELECT pack_id,street_name || ' zona_'||st_geohash(geom,6), house_number, geom
    FROM prep
    WHERE  street_name||house_number IN (SELECT sthn FROM prep_dup_addr)

  ON CONFLICT  DO NOTHING -- 715795; union up to 724697 but 723764 deleting dups.
;
-- test:
SELECT pack_id, ghs, n, round(n*1000000/area) as n_km2 FROM
  (SELECT pack_id, st_geohash(geom,4) ghs, count(*) n from ingest.addr_point group by 1,2 order by 1,2) t,
  LATERAL  (SELECT ST_AREA(ST_GeomFromGeoHash(t.ghs),true) as area) t2
;
--   select distinct streetname from ingest.addr_point order by 1;

DROP Foreign table tmp_orig.fdw_enderecos_br_pk012;

--rendre la table de panneaus propre et en projection geo
ALTER TABLE panneaus drop constraint enforce_srid_the_geom;
UPDATE geometry_columns set srid=32187 where f_table_name='panneaus';
UPDATE panneaus set the_geom=ST_SetSRID(the_geom,32187);
UPDATE panneaus set the_geom=ST_Transform(the_geom,4326);
UPDATE geometry_columns set srid=4326 where f_table_name='panneaus';

--placer en minusculs les nom de champ
select DropGeometryTable('vq','aqreseau_l');
create table vq.aqreseau_l as 
select gid,"IdRte" as idrte ,"Version" as version_ ,"NomRte" as nomrte ,"NoRte" as norte,
"ClsRte" as clsrte ,"CaractRte" as caractrte ,the_geom from vq.aqreseau_vq

--register
INSERT INTO geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, "type")
SELECT '', 'vq', 'aqreseau_l', 'the_geom', ST_CoordDim(the_geom), ST_SRID(the_geom), GeometryType(the_geom)
FROM vq.aqreseau_vq LIMIT 1;
select * from "vq"."aqreseau_l" limit 1
select  ST_IsValidReason(the_geom) from "vq"."aqreseau_l" 
UPDATE vq.aqreseau_l set the_geom=ST_SetSRID(the_geom,4326);

--Ajouter un champ ligne et point à la table de travaux
SELECT AddGeometryColumn ('vq','travaux','the_geom_p',4326,'POINT',2);
SELECT AddGeometryColumn ('vq','travaux','the_geom_l',4326,'LINESTRING',2);

--Créer une view (point,ligne) pour simplifier les requêtes et/ou affichage dans QGis
CREATE VIEW travaux_l AS SELECT 

--Register view dans le catalog PG
INSERT INTO geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, "type")
SELECT '', 'vq', 'travaux_l', 'the_geom_l', ST_CoordDim(the_geom_l), ST_SRID(the_geom_l), GeometryType(the_geom_l)
FROM vq.travaux LIMIT 1;

select * from vq.travaux;

--Placer dans le champ ligne de la table travaux une ligne identifiée à partire de AQréseau.
UPDATE vq.travaux set the_geom_l = (select the_geom_l from vq.travaux where endroit1='247456') where oid=247456;
ROLLBACK
delete from vq.travaux where oid > 247456;
UPDATE vq.travaux set the_geom_l =null where oid<>247442;
--Placer dans le champ point de la table travaux un point 
--interpolé sur un segment identifié à partire de AQréseau à 50% de sa longueur
UPDATE vq.travaux set the_geom_p =  ST_Line_Interpolate_Point(the_geom_l,0.5) where oid=247456;
--Description : Requête qui retourne les 
select datedebuttravaux,datefintravaux,endroit1,endroit2,
       arrondissement,emplacement,restriction,naturetravaux,id
from vq.travaux where ST_Intersects(the_geom,ST_GeomFromText('POINT(-71.2109531995375 46.8148285329402)',4326))=false

--Description retourne les travaux en WKT
select ST_AsText(the_geom_l) from vq.travaux

--Description : Requête qui retourne les rues autour d'un point spécifique selon un rayon donnée.  La requête va
--              exclure la rue (selon son nom) qui intersecte avec le point passé en paramètre.  L'objectif
--              est de trouver un parpour alternatif à celui qui intersecte avec des travaux de la ville
--Besoin
--    String WKT d'un Point
--    Rayon en mètre de recherche de rue alternative 
--    Tolérance de recherche pour la recherche de la rue à exclure.
SELECT nomrte FROM (SELECT nomrte,ST_Distance(multiline_interpolate_point(the_geom,0.5),ST_Transform(ST_GeomFromText('POINT(-71.2109531995375 46.8148285329402)',4326),3798)) AQ dist_
FROM aq_routes 
WHERE ST_Intersects(the_geom,ST_Buffer(ST_Transform(ST_GeomFromText('POINT(-71.2109531995375 46.8148285329402)',4326),3798),60+(60*0.25)))
AND nomrte!=(FROM nomrte FROM aq_routes 
WHERE ST_Intersects(the_geom,ST_Buffer(ST_Transform(ST_GeomFromText('POINT(-71.2109531995375 46.8148285329402)',4326),3798),10))=TRUE
)ORDER BY dist_) as foo GROUP BY nomrte


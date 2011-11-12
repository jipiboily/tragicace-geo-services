CREATE OR REPLACE FUNCTION multiline_interpolate_point(amultils
geometry,location float8)
  RETURNS geometry AS
$BODY$
DECLARE
    accumlength float8;
    totallength float8;
    nearestpoint geometry;
    i integer;
f
BEGIN
    IF ((location < 0) or (location > 1)) THEN
    RAISE EXCEPTION 'location must be between 0 and 1 --> %', location;
    END IF;
    IF (GeometryType(amultils) != 'LINESTRING') and (GeometryType(amultils)
!= 'MULTILINESTRING') THEN
    RAISE EXCEPTION 'the geometry must be a LINESTRING or a
MULTILINESTRING';
    END IF;

    IF (GeometryType(amultils) = 'LINESTRING') THEN
    nearestpoint:=line_interpolate_point(amultils,location);
    RETURN nearestpoint;
    END IF;
    accumlength := 0;
    totallength := Length(amultils);
    FOR i IN 1 .. NumGeometries(amultils) LOOP
        IF ((accumlength + Length(GeometryN(amultils,i))/totallength) >=
location) THEN
            IF
((location-accumlength)/(Length(GeometryN(amultils,i))/totallength) > 1)
THEN

nearestpoint:=line_interpolate_point(GeometryN(amultils,i),1);
            ELSE

nearestpoint:=line_interpolate_point(GeometryN(amultils,i),(location-accumlength)/(Length(GeometryN(amultils,i))/totallength));
            END IF;
            EXIT;
        ELSE

accumlength:=accumlength+Length(GeometryN(amultils,i))/totallength;
        END IF;
    END LOOP;
    RETURN nearestpoint;
END;
$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION multiline_interpolate_point(amultils geometry,location
float8) OWNER TO postgres;
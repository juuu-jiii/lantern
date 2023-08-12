-- functions
CREATE FUNCTION ldb_generic_dist(real[], real[]) RETURNS real
	AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION cos_dist(real[], real[]) RETURNS real
	AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION ham_dist(real[], real[]) RETURNS real
	AS 'MODULE_PATHNAME' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- operators

DROP OPERATOR IF EXISTS <->;
CREATE OPERATOR <-> (
	LEFTARG = real[], RIGHTARG = real[], PROCEDURE = ldb_generic_dist,
	COMMUTATOR = '<->'
);

-- operator classes
CREATE OPERATOR CLASS ann_cos_ops
FOR TYPE real[] USING hnsw AS
	OPERATOR 1 <-> (real[], real[]) FOR ORDER BY float_ops,
	FUNCTION 1 cos_dist(real[], real[]);

CREATE OPERATOR CLASS ann_ham_ops
	FOR TYPE real[] USING hnsw AS
	OPERATOR 1 <-> (real[], real[]) FOR ORDER BY float_ops,
	FUNCTION 1 ham_dist(real[], real[]);
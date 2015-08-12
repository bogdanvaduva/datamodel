DROP VIEW IF EXISTS qgep.vw_prank_weir;

CREATE OR REPLACE VIEW qgep.vw_prank_weir AS

SELECT
   PW.obj_id
   , PW.hydraulic_overflow_length
   , PW.level_max
   , PW.level_min
   , PW.weir_edge
   , PW.weir_kind
   , OF.actuation
   , OF.adjustability
   , OF.brand
   , OF.control
   , OF.discharge_point
   , OF.function
   , OF.gross_costs
   , OF.identifier
   , OF.qon_dim
   , OF.remark
   , OF.signal_transmission
   , OF.subsidies
   , OF.dataowner
   , OF.provider
   , OF.last_modification
  , OF.fk_wastewater_node
  , OF.fk_overflow_to
  , OF.fk_overflow_characteristic
  , OF.fk_control_center
  FROM qgep.od_prank_weir PW
 LEFT JOIN qgep.od_overflow OF
 ON OF.obj_id = PW.obj_id;

-----------------------------------
-- prank_weir INSERT
-- Function: vw_prank_weir_insert()
-----------------------------------

CREATE OR REPLACE FUNCTION qgep.vw_prank_weir_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep.od_overflow (
             obj_id
           , actuation
           , adjustability
           , brand
           , control
           , discharge_point
           , function
           , gross_costs
           , identifier
           , qon_dim
           , remark
           , signal_transmission
           , subsidies
           , dataowner
           , provider
           , last_modification
           , fk_wastewater_node
           , fk_overflow_to
           , fk_overflow_characteristic
           , fk_control_center
           )
     VALUES ( qgep.generate_oid('od_prank_weir') -- obj_id
           , NEW.actuation
           , NEW.adjustability
           , NEW.brand
           , NEW.control
           , NEW.discharge_point
           , NEW.function
           , NEW.gross_costs
           , NEW.identifier
           , NEW.qon_dim
           , NEW.remark
           , NEW.signal_transmission
           , NEW.subsidies
           , NEW.dataowner
           , NEW.provider
           , NEW.last_modification
           , NEW.fk_wastewater_node
           , NEW.fk_overflow_to
           , NEW.fk_overflow_characteristic
           , NEW.fk_control_center
           )
           RETURNING obj_id INTO NEW.obj_id;

INSERT INTO qgep.od_prank_weir (
             obj_id
           , hydraulic_overflow_length
           , level_max
           , level_min
           , weir_edge
           , weir_kind
           )
          VALUES (
            NEW.obj_id -- obj_id
           , NEW.hydraulic_overflow_length
           , NEW.level_max
           , NEW.level_min
           , NEW.weir_edge
           , NEW.weir_kind
           );
  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- DROP TRIGGER vw_prank_weir_ON_INSERT ON qgep.prank_weir;

CREATE TRIGGER vw_prank_weir_ON_INSERT INSTEAD OF INSERT ON qgep.vw_prank_weir
  FOR EACH ROW EXECUTE PROCEDURE qgep.vw_prank_weir_insert();

-----------------------------------
-- prank_weir UPDATE
-- Rule: vw_prank_weir_ON_UPDATE()
-----------------------------------

CREATE OR REPLACE RULE vw_prank_weir_ON_UPDATE AS ON UPDATE TO qgep.vw_prank_weir DO INSTEAD (
UPDATE qgep.od_prank_weir
  SET
       hydraulic_overflow_length = NEW.hydraulic_overflow_length
     , level_max = NEW.level_max
     , level_min = NEW.level_min
     , weir_edge = NEW.weir_edge
     , weir_kind = NEW.weir_kind
  WHERE obj_id = OLD.obj_id;

UPDATE qgep.od_overflow
  SET
       actuation = NEW.actuation
     , adjustability = NEW.adjustability
     , brand = NEW.brand
     , control = NEW.control
     , discharge_point = NEW.discharge_point
     , function = NEW.function
     , gross_costs = NEW.gross_costs
     , identifier = NEW.identifier
     , qon_dim = NEW.qon_dim
     , remark = NEW.remark
     , signal_transmission = NEW.signal_transmission
     , subsidies = NEW.subsidies
           , dataowner = NEW.dataowner
           , provider = NEW.provider
           , last_modification = NEW.last_modification
     , fk_wastewater_node = NEW.fk_wastewater_node
     , fk_overflow_to = NEW.fk_overflow_to
     , fk_overflow_characteristic = NEW.fk_overflow_characteristic
     , fk_control_center = NEW.fk_control_center
  WHERE obj_id = OLD.obj_id;
);

-----------------------------------
-- prank_weir DELETE
-- Rule: vw_prank_weir_ON_DELETE ()
-----------------------------------

CREATE OR REPLACE RULE vw_prank_weir_ON_DELETE AS ON DELETE TO qgep.vw_prank_weir DO INSTEAD (
  DELETE FROM qgep.od_prank_weir WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep.od_overflow WHERE obj_id = OLD.obj_id;
);


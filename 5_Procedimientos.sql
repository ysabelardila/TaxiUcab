/*Procedimiento 1*/
--Falta el tipo
create or replace procedure reporte_uno (prc out sys_refcursor)
is
begin
    open prc for select * from reporte1;
end;

/*Procedimiento 2*/
--
create or replace procedure reporte_dos (prc out sys_refcursor)
is
begin
    open prc for select * from reporte2;
end;
/
/*Procedimiento 3*/
--
create or replace procedure reporte_tres (fecha1 in date, fecha2 in date, prc out sys_refcursor)
is
begin
    open prc for select o.datos_conductor.nombres, o.datos_conductor.apellidos, o.usuario, o.foto,
    (select count(serv1.id_cond) from servicio serv1 where serv1.id_cond=o.id_conductor and serv1.estatus like 'completado' 
    and serv1.fecha_hora between fecha1 and fecha2), 

	(select count(serv2.id_cond) from servicio serv2 where serv2.id_cond=o.id_conductor and serv2.estatus like 'no completado'
    and serv2.fecha_hora between fecha1 and fecha2)
	from conductor o;
end;
/
/*Procedimiento 4*/
--
create or replace procedure reporte_cuatro (prc out sys_refcursor)
is
begin
    open prc for select * from reporte4;
end;
/
/*Procedimiento 5*/
--
create or replace procedure reporte_cinco (prc out sys_refcursor)
is
begin
    open prc for select * from reporte5;
end;
/
/*Procedimiento 6*/
--
create or replace procedure reporte_seis (prc out sys_refcursor)
is
begin
    open prc for select * from reporte6;
end;
/

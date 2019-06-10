create profile generalisimo
limit
    failed_login_attempts 5
    password_reuse_time 180
    cpu_per_session unlimited;

create user cliente IDENTIFIED BY cliente1 profile generalisimo;
create user conductor IDENTIFIED BY cliente1 profile generalisimo;
create user rr_hh IDENTIFIED BY cliente1 profile generalisimo;
cerate user administrador IDENTIFIED BY cliente1 profile generalisimo;
cerate user analista_finanzas IDENTIFIED BY cliente1 profile generalisimo;


/*cliente*/
grant create session to cliente;
grant select, insert, delete, update on cliente to cliente;
grant select, insert, delete, update on usuario to cliente;
grant select, insert, delete, update on servicio to cliente;
grant select, insert, delete, update on favorito to cliente;
grant select, insert, delete, update on tarjeta_credito to cliente;
grant select, insert, delete, update on monedero_virtual to cliente;
grant select, insert, delete, update on hist_monedero to cliente;
grant select, insert, delete, update on pago_servicio to cliente;
grant select on conductor to cliente;
grant select on ruta to cliente;
grant select on parroquia to cliente;
grant select on vehiculo to cliente;
grant select on foto to cliente;


/**/


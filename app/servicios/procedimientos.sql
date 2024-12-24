delimiter $$
create procedure iniciarSesion(in cor varchar(70), in con varchar(32), out accion tinyint unsigned)
begin
	declare conTemp varchar(32);
    select contrasena into conTemp from cuenta where correo = cor;
    if conTemp is not null then
		if conTemp = con then
			set accion = 1;
		else
			set accion = 2;
		end if;
	else
		set accion = 3;
	end if;
end $$
delimiter ;

delimiter $$
create procedure registrarCuenta(in cor varchar(70), in con varchar(32), in rol tinyint, in dni varchar(8), in nom varchar(50), 
in ape varchar(50), in tel varchar(9))
begin
	insert into cuenta (correo, contrasena, idRol) values (cor, con, rol);
    set @idCue = LAST_INSERT_ID();
    insert into persona (idCuenta, dni, nombres, apellidos, telefono) values (@idCue, dni, nom, ape, tel);
end $$
delimiter ;

delimiter $$
create procedure registrarProducto(in nom varchar(150), in cat varchar(40), in pro varchar(30), in pre float, in sto tinyint, in ofe float, in ima varchar(100))
begin
	declare idCat tinyint;
    declare idProv smallint;
    select idCategoria into idCat from categoria where categoria = cat;
    select idProveedor into idProv from proveedor where proveedor = pro;
    insert into producto (nombre, idCategoria, idProveedor, precio, stock, oferta, imagen) values (nom, idCat, idProv, pre, sto, ofe, ima);
end $$
delimiter ;

delimiter $$
create procedure modificarProducto(in id smallint, in nom varchar(150), in cat varchar(40), in pro varchar(30), in pre float, in sto tinyint, in ofe float, in ima varchar(100))
begin
	declare idCat tinyint;
    declare idProv smallint;
    select idCategoria into idCat from categoria where categoria = cat;
    select idProveedor into idProv from proveedor where proveedor = pro;
    update producto set nombre = nom, idCategoria = idCat, idProveedor = idProv, precio = pre, stock = sto, oferta = ofe, imagen = ima where idProducto = id;
end $$
delimiter ;

delimiter $$
create procedure registrarSugerencia(in id int, in asu varchar(70), in sug text, in fec datetime)
begin
	insert into sugerencia (idCuenta, asunto, sugerencia, fecha) values (id, asu, sug, fec);
end $$
delimiter ;

delimiter $$
create procedure registrarReclamo(in id int, in rec text, in fec datetime)
begin
	insert into reclamo (idCuenta, reclamo, fecha) values (id, rec, fec);
end $$
delimiter ;

delimiter $$
create procedure registrarVenta(in idCue int, in fec datetime, in tpa tinyint, in ten tinyint, in dir varchar(100), in pto float)
begin
	insert into venta (idCuenta, fecha, idTipoPago, idTipoEntrega, direccion, precioTotal) values (idCue, fec, tpa, ten, dir, pto);
    set @idUltimaVenta = LAST_INSERT_ID();
end $$
delimiter ;

delimiter $$
create procedure registrarDetalleVenta(in idVen int, in idPro smallint, in can tinyint, sub float)
begin
	insert into detalleVenta (idVenta, idProducto, cantidad, subtotal) values (idVen, idPro, can, sub);
end $$
delimiter ;

delimiter $$
create trigger actualizarStock after insert on detalleVenta for each row
begin
	set @idPro = new.idProducto;
    set @cant = new.cantidad;
    update producto set stock = stock - @cant where idProducto = @idPro;
end $$
delimiter ;
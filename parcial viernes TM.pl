% Parcial: Un día de furia
% https://docs.google.com/document/d/1omdRN-eP55lkusU-iT43EhN_whK885tgFrJBE1zUwfQ/edit?usp=sharing

%cotizacion(moneda,hora,cotizacion).
cotizacion(dolar,8, 43).
cotizacion(lira, 8, 41).
cotizacion(dolar,9, 43.5).
cotizacion(lira, 9, 39).
cotizacion(dolar,10, 43.8).
cotizacion(lira, 10, 38).
cotizacion(patacon, 9, 200).
cotizacion(patacon, 10, 200).

%1) Cotizaciones
variacionDeLaMoneda(Moneda, Hora, Incremento):-
    cotizacion(Moneda, Hora, Cotizacion),
    HoraAnterior is Hora -1,
    cotizacion(Moneda, HoraAnterior, CotizacionAnterior),
    Incremento is Cotizacion- CotizacionAnterior.

aCuantoCerroMoneda(Moneda, Cotizacion):-
    cotizacion(Moneda, HoraFinal, Cotizacion),
    not((cotizacion(Moneda, Hora, _), Hora > HoraFinal)).

%2) Transacciones

%transaccion(persona, hora, cantidadComprada, moneda)
transaccion(juanCarlos, 8, 1000, dolar).
transaccion(juanCarlos, 9, 1000, lira).
transaccion(ypf, 10, 100005349503495035930, dolar).

hizoTransaccionesConMasDeUnaMoneda(Persona):-
    transaccion(Persona, _, _, Moneda),
    transaccion(Persona, _, _, OtraMoneda),
    Moneda\= OtraMoneda.

noHuboTransacciones(Moneda):-
    cotizacion(Moneda,_, _),
    not(transaccion(_, _, _, Moneda)).


transaccionAlta(Persona):-
    transaccionEnPesos(Persona, Importe),
    Importe >1000000.


transaccionEnPesos(Persona, Importe):-
    transaccion(Persona, Hora, Cantidad, Moneda),
    cotizacion(Moneda,Hora,Cotizacion),
    Importe is Cantidad * Cotizacion.


totalTransaccionesEnPesos(Persona,Total):-
    transaccion(Persona,_,_,_),
    findall(Importe, transaccionEnPesos(Persona,Importe), Importes),
    sumlist(Importes,Total).

%3) Llego la AFIP

%cuenta(persona, saldo, banco).
cuenta(juanCarlos, 100, hete).
cuenta(juanCarlos, 2000, nejo).
cuenta(ypf, 10000000, nejo).

%persona(persona, situacion)
persona(juanCarlos, laburante(colectivero, rioNegro)).
persona(romina, laburante(docente, santaFe)).
persona(julian, juez).
persona(ypf, empresa(5000)).

%salario(ocupacion, salario)%
salario(colectivero, 3000000).
salario(docente, 20000).

transaccionSuperiorALoDeclarado(Persona):-
    transaccionEnPesos(Persona, Importe),
    forall(cuenta(Persona,Saldo,_),Importe > Saldo).

transaccionMayorAlLimiteDiario(Persona):-
    transaccionEnPesos(Persona, Importe),
    limiteDiario(Persona, Limite),
    Importe > Limite.

limiteDiario(Persona,Limite):-
    persona(Persona, Situacion),
    limite(Situacion, Limite).

limite(laburante(Ocupacion,Lugar), Limite):-
    salario(Ocupacion, Salario),
    adicional(Lugar, Adicional),
    Limite is Salario*0.1 + Adicional.

limite(empresa(Empleados),Limite):-
    Limite is Empleados *1000.

adicional(buenosAires, 500).
adicional(Lugar , 0):-
      Lugar \= buenosAires.

%el juez no tiene limite























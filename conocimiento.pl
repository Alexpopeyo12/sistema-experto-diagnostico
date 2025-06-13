:- dynamic sintoma/1.

% --- Hechos base ---
sintoma(sin_internet).
sintoma(ip_incorrecta).
sintoma(dns_falla).
sintoma(monitor_no_enciende).
sintoma(teclado_no_funciona).
sintoma(programas_cierran).
sintoma(sistema_lento).

% --- Reglas de diagnóstico ---
diagnostico(falla_red) :-
    sintoma(sin_internet),
    sintoma(ip_incorrecta).

diagnostico(falla_dns) :-
    sintoma(sin_internet),
    sintoma(dns_falla).

diagnostico(falla_hardware_monitor) :-
    sintoma(monitor_no_enciende).

diagnostico(falla_hardware_teclado) :-
    sintoma(teclado_no_funciona).

diagnostico(falla_software) :-
    sintoma(programas_cierran);
    sintoma(sistema_lento).

sugerir_diagnostico(S) :-
    diagnostico(S), !.
sugerir_diagnostico(sin_diagnostico).
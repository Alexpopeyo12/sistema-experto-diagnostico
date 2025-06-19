
% ==========================================
% Sistema Gestor de Control Escolar en Prolog
% ==========================================
:- set_prolog_flag(encoding, utf8).

% ---------------------------
% 1. Declaración de hechos
% ---------------------------

% alumno(ID, Nombre).
% Define a los alumnos con un identificador único y su nombre
alumno(1, 'Ana Lopez').
alumno(2, 'Carlos Ruiz').
alumno(3, 'Maria Gomez').

% materia(ID, Nombre).
% Define las materias con un identificador único y su nombre
materia(101, 'Matematicas').
materia(102, 'Historia').
materia(103, 'Programacion').

% inscrito(AlumnoID, MateriaID).
% Indica que un alumno está inscrito en una materia
inscrito(1, 101).
inscrito(1, 103).
inscrito(2, 102).
inscrito(3, 101).
inscrito(3, 102).
inscrito(3, 103).

% calificacion(AlumnoID, MateriaID, Calificacion).
% Guarda la calificación de un alumno en una materia
calificacion(1, 101, 9.0).
calificacion(1, 103, 8.5).
calificacion(2, 102, 7.0).
calificacion(3, 101, 6.5).
calificacion(3, 102, 8.0).
calificacion(3, 103, 9.5).

% ---------------------------
% 2. Consultas funcionales
% ---------------------------

% materias_de_alumno(NombreAlumno, Materia)
% Devuelve las materias en las que está inscrito un alumno
materias_de_alumno(NombreAlumno, Materia) :-
    alumno(ID, NombreAlumno),                  % Busca el ID del alumno según su nombre
    inscrito(ID, IDMateria),                   % Verifica que esté inscrito a una materia
    materia(IDMateria, Materia).               % Devuelve el nombre de la materia

% calificaciones_de_alumno(NombreAlumno, Materia, Calificacion)
% Devuelve las calificaciones de un alumno con nombres de materias
calificaciones_de_alumno(NombreAlumno, Materia, Calificacion) :-
    alumno(ID, NombreAlumno),
    calificacion(ID, IDMateria, Calificacion),
    materia(IDMateria, Materia).

% alumnos_en_materia(NombreMateria, NombreAlumno)
% Lista los alumnos inscritos a una materia especifica
alumnos_en_materia(NombreMateria, NombreAlumno) :-
    materia(IDMateria, NombreMateria),
    inscrito(IDAlumno, IDMateria),
    alumno(IDAlumno, NombreAlumno).

% ---------------------------
% 3. Cálculo de promedios y estatus
% ---------------------------

% promedio_alumno(NombreAlumno, Promedio)
% Calcula el promedio de calificaciones de un alumno
promedio_alumno(NombreAlumno, Promedio) :-
    alumno(ID, NombreAlumno),                      % Encuentra el ID del alumno
    findall(C, calificacion(ID, _, C), Calificaciones), % Obtiene todas sus calificaciones
    Calificaciones \= [],                          % Asegura que haya al menos una calificación
    sum_list(Calificaciones, Suma),                % Suma todas las calificaciones
    length(Calificaciones, N),                     % Cuenta cuántas calificaciones hay
    Promedio is Suma / N.                          % Calcula el promedio

% estatus(Promedio, Estatus)
% Asigna un estatus académico en función del promedio
estatus(Promedio, 'Excelente') :- Promedio >= 9.0.
estatus(Promedio, 'Notable')   :- Promedio >= 8.0, Promedio < 9.0.
estatus(Promedio, 'Bueno')     :- Promedio >= 7.0, Promedio < 8.0.
estatus(Promedio, 'Suficiente'):- Promedio >= 6.0, Promedio < 7.0.
estatus(Promedio, 'Reprobado') :- Promedio < 6.0.

% estatus_de_alumno(NombreAlumno, Estatus)
% Obtiene el estatus académico de un alumno por nombre
estatus_de_alumno(NombreAlumno, Estatus) :-
    promedio_alumno(NombreAlumno, Promedio),       % Calcula su promedio
    estatus(Promedio, Estatus).                    % Evalúa su nivel según ese promedio

% ---------------------------
% 4. Validación y manejo de errores
% ---------------------------

% existe_alumno(Nombre)
% Verifica si un alumno existe. Si no, muestra error y falla
existe_alumno(Nombre) :-
    alumno(_, Nombre), !.
existe_alumno(Nombre) :-
    format("Error: El alumno '~w' no esta registrado.~n", [Nombre]), fail.

% existe_materia(Nombre)
% Verifica si una materia existe. Si no, muestra error y falla
existe_materia(Nombre) :-
    materia(_, Nombre), !.
existe_materia(Nombre) :-
    format("Error: La materia '~w' no esta registrada.~n", [Nombre]), fail.

% calificacion_valida(C)
% Verifica si una calificación está entre 0 y 10
calificacion_valida(C) :-
    number(C), C >= 0, C =< 10, !.
calificacion_valida(C) :-
    format("Error: Calificacion invalida (~w). Debe estar entre 0 y 10.~n", [C]), fail.

% ---------------------------
% 5. Interfaz básica de consulta
% ---------------------------

% reporte_alumno(Nombre)
% Muestra un reporte completo: materias, calificaciones, promedio y estatus
reporte_alumno(Nombre) :-
    existe_alumno(Nombre),                             % Valida existencia del alumno
    writeln("====== REPORTE DE ALUMNO ======"),        % Imprime encabezado
    format("Alumno: ~w~n", [Nombre]),                  % Imprime el nombre
    calificaciones_de_alumno(Nombre, Materia, Cal),    % Itera sobre cada materia y calificación
    format(" - ~w: ~1f~n", [Materia, Cal]),            % Imprime cada una
    fail.                                              % Fuerza backtracking para seguir listando
reporte_alumno(Nombre) :-
    promedio_alumno(Nombre, P),                        % Calcula el promedio
    estatus(P, E),                                     % Determina el estatus
    format("Promedio: ~2f~n", [P]),                    % Imprime promedio
    format("Estatus: ~w~n", [E]).                      % Imprime estatus

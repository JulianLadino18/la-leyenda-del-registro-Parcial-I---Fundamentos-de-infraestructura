# Examen — La Leyenda del Registro

**Asignatura:** Fundamentos de Infraestructura
**Unidad:** Ensamblador x86-64 (NASM) — Clases 1, 2 y 3
**Duración:** 90 minutos
**Modalidad:** individual, en la VM de Ubuntu con NASM instalado
**Material permitido:** las carpetas `clase-01/`, `clase-02/`, `clase-03/` y la documentación de syscalls de Linux. **No** se permite internet, IA generativa ni copiar entre estudiantes.

---

## Instrucciones generales

1. Trabaja dentro de tu propia carpeta de examen. Copia las tres clases a `examen/clase-01`, `examen/clase-02`, `examen/clase-03`.
2. **Cada entrega es un archivo.** Donde se pide "muestra", pega la salida real entre bloques de código. No inventes salidas: el profesor puede re-ejecutar tu binario.
3. **Parte práctica:** los artefactos (salidas, `strace`, código modificado, binarios) van en `examen/entrega.md` (creas tú este archivo).
4. **Preguntas conceptuales** (tanto de la Parte A como de la B) se responden directamente en este documento, dentro de los bloques `[RESOLVER AQUÍ]`.
5. Al final, entrega: tu carpeta `examen/` con los `.asm`, los binarios, `entrega.md` y este `examen.md` con las respuestas.

**Criterio de aprobación:** ≥ 70% de la nota total. Cada sección indica su puntaje.

---

# PARTE A — PRÁCTICA: seguir y ejecutar las clases (60 pts)

> Regla de oro: si algo no compila, no pasa a la siguiente. **No se acepta "no compiló" como respuesta.**
> Documenta el error completo y el intento de solución.

---

## A.1 — El despertar (Clase 1) — 10 pts

### A.1.1 (4 pts)
Compila y ejecuta la clase 1. Documenta en `entrega.md`:

- El comando exacto de compilación y el de enlazado.
- La salida completa del programa.
- El código de salida (`echo $?`).

### A.1.2 (6 pts)
Ejecuta `strace -e trace=write,exit_group ./clase01 2> trace1.txt` y responde (pega también el
`strace` en `entrega.md`):

1. ¿Cuántas llamadas `write` hay en total?
2. ¿Cuál es el código de salida que devuelve `exit_group`?
3. ¿Qué número de syscall usa `write`? (pista: mira la columna `syscall` o el `strace` completo).

[RESOLVER AQUÍ: ]

strace -e trace=write,exit_group ./clase01 2> trace1.txt
write(1, "LA LEYENDA DEL REGISTRO v0.1\n", 29) = 29
write(1, "Bienvenido, heroe. Tu aventura e"..., 45) = 45
write(1, "El sistema operativo te despidio"..., 60) = 60
+++ exited with 0 +++

1. Hay 3 llamadas write (titulo, bienvenida, despedida).
2. El codigo de salida es 0. El programa termina con mov rax, 60 (sys_exit), no con exit_group (231); por eso el filtro no muestra ninguna linea exit_group y strace solo informa +++ exited with 0 +++.
3. write es la syscall numero 1 ya que se carga en rax con mov rax, 1.

---

## A.2 — El nombre del héroe (Clase 2) — 15 pts

### A.2.1 (5 pts)
Compila y ejecuta la clase 2 con **tres** nombres distintos:

1. Un nombre corto (≤ 5 letras).
2. Un nombre de **exactamente 31** letras.
3. Un nombre de **40** letras.

Documenta la salida de cada caso en `entrega.md`.

[RESOLVER AQUÍ: ¿Qué ocurre en el caso 3? Explica por qué, citando qué línea del `.asm` lo provoca.]

Caso 1 - nombre corto: Ana
LA LEYENDA DEL REGISTRO v0.2
Como se llama el heroe? (max 31 letras)
Bienvenido al reino, Ana
Tu nombre ya vive en la memoria del proceso.

Caso 2 - 31 letras
LA LEYENDA DEL REGISTRO v0.2
Como se llama el heroe? (max 31 letras)
Bienvenido al reino, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Tu nombre ya vive en la memoria del proceso.

Caso 3 - 40 letras
LA LEYENDA DEL REGISTRO v0.2
Como se llama el heroe? (max 31 letras)
Bienvenido al reino, BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
Tu nombre ya vive en la memoria del proceso.

Que ocurre en el caso 3: el programa no se rompe,
pero atranca el nombre: imprime solo las primeras 32 letras. 
La causa es la linea mov rdx, 32 de la Accion 3 (el read):
el kernel nunca copia mas de 32 bytes al buffer nombre (resb 32),
asi que no hay desbordamiento. Como esos 32 bytes son todos letras
(no hay LF al final), el cmp byte [nombre + rax - 1], 10 da distinto
y se salta el dec rax, de modo que se imprimen 32 letras (no 31).
Las 8 letras sobrantes y el Enter quedan en el buffer de stdin;
en una terminal real la shell las ejecutaria despues como un comando.
En el caso 2 (31 letras + LF = 32 bytes) todo cabe y se imprimen 31 letras
### A.2.2 (5 pts)
Ejecuta `strace -e trace=read,write ./clase02` con un nombre de 10 letras (pega el `strace` en `entrega.md`) y responde:

1. ¿Cuántos bytes devuelve la llamada `read`?
2. ¿Por qué ese número y no 32 (el tamaño del buffer)?
3. ¿En qué variable del código se guarda ese valor de retorno?

[RESOLVER AQUÍ: ]

strace -e trace=read,write ./clase02
write(1, "LA LEYENDA DEL REGISTRO v0.2\n", 29) = 29
write(1, "Como se llama el heroe? (max 31 "..., 40) = 40
read(0, "Aragorn123\n", 32) = 11
write(1, "Bienvenido al reino, ", 21) = 21
write(1, "Aragorn123", 10) = 10
write(1, "\n", 1) = 1
write(1, "Tu nombre ya vive en la memoria "..., 45) = 45
+++ exited with 0 +++

1. read devuelve 11 bytes (10 letras + el LF del Enter).
2. Porque 32 es solo el maximo que se le permite leer, read devuelve cuantos bytes habia realmente disponibles (lo que el usuario escribio hasta el Enter).
3. En la variable lon (mov [lon], rax, de resq 1 en .bss). Luego se decrementa a 10 al quitar el LF con dec rax y se vuelve a guardar en lon.

### A.2.3 (5 pts) — Modificación obligatoria
En tu copia de `clase02.asm`, cambia **dos** cosas y haz que siga compilando y ejecutando:

1. Cambia el saludo (`saludo`) a una frase tuya (debe incluir "reino" o "heroe").
2. Cambia la despedida (`despedida`) a una frase tuya.

Pega en `entrega.md` el bloque `.data` modificado y la salida de tu programa con el nombre `Gandalf`.

---

## A.3 — Los atributos del héroe (Clase 3) — 20 pts

### A.3.1 (8 pts)
Compila la clase 3 y ejecútala con las **cinco** combinaciones de (FUE, AGI) de la tabla. Completa la tabla con la salida real (ELITE / NOVATO / ERROR) y el código de salida:

| Caso | FUE | AGI | ¿ELITE o NOVATO o ERROR? | Código salida (`$?`) |
|------|-----|-----|--------------------------|----------------------|
| 1    | 3   | 5   |                          |                      |
| 2    | 0   | 9   |                          |                      |
| 3    | 9   | 9   |                          |                      |
| 4    | 0   | 0   |                          |                      |
| 5    | `x` | 5   |                          |                      |

> Caso 5: en lugar de un dígito, escribe la letra `x`.

[RESOLVER AQUÍ: ¿Qué hace el programa con la letra `x`? ¿Por qué no se rompe?]
El programa interpreta cualquier valor que no sea un digito como un 0, esto causa que el programa no tenga que romperse y resultar en error. En el caso 5, `FUE` automaticamente resulta en 0 y los puntos de vida en 4

### A.3.2 (6 pts)
Con `strace -e trace=write,read,exit_group ./clase03`, usando FUE=8, AGI=2 (pega el `strace` en `entrega.md`), responde:

1. ¿Cuántas llamadas `write` hay? Enuméralas (qué texto escribe cada una).
2. ¿Cuántas llamadas `read` hay?
3. ¿Por qué `read` devuelve siempre `2` y no `1`?

[RESOLVER AQUÍ: ]
Utilizando FUE = 8 y AGI = 2
1. Hay 5 llamadas `write`
    I.      LA LEYENDA DEL REGISTRO v0.3
    II.     Tienes 9 puntos para repartir. El resto se vuelve vida (VID).
    III.    FUE (fuerza, 0 a 9): 
    IV.     AGI (agilidad, 0 a 9):
    V.      Error: no te alcanzan los 9 puntos.

2. Hay 2 llamada del tipo `read` las cuales fueron para introducir los valores de FUE (8) y AGI (2)

3. Read siempre devuelve el valor de 2, ya que es la cantidad de bytes que ocupa en memoria, el digito introducido y el salto de linea. Por ejemplo:`"8\n"`

### A.3.3 (6 pts) — Modificación obligatoria
Implementa el **Ejercicio 1** de la clase 3 ("El heroe se enfada"): si FUE es 0, muestra la frase
`"Un heroe sin fuerza no es heroe."` y sigue el flujo normal.

Requisitos:

- Usa `cmp byte [v_fue], 0` y un salto `je` a un bloque nuevo `.sin_fuerza`.
- El programa debe seguir imprimiendo el bloque de atributos y terminar con código 0.
- Pega en `entrega.md` las líneas que agregaste y la salida completa con FUE=0, AGI=3.

---

## A.4 — Crear desde cero (15 pts)

Escribe un programa **nuevo** (`examen/heroe.asm`) **sin usar libc** que:

1. Imprima `"Nombre: "` (sin salto de línea).
2. Lea el nombre desde el teclado (buffer de 16 bytes en `.bss`).
3. Imprima el nombre.
4. Imprima un salto de línea.
5. Termine con código de salida 0.

Compílalo con `nasm -f elf64` y `ld`. Pega en `entrega.md` el código completo y la salida al ejecutarlo con el nombre `Sauron`.

> No copies la clase 2: el programa debe ser más corto (solo 4 `write`/`read` + `exit`).

---

# PARTE B — TEORÍA: preguntas (40 pts)

> Responde dentro de los bloques `[RESOLVER AQUÍ]`.
> Se valora **explicar con tus palabras**, no solo la respuesta correcta.

---

## B.1 — Selección múltiple (5 pts, 1 pt c/u)

**1.** ¿Cuál es el número de syscall de `sys_write` en Linux x86-64?

- a) 0
- b) 1
- c) 60
- d) 2

[RESOLVER AQUÍ: ]

---

**2.** ¿En qué registro se pone el **número de syscall** antes de ejecutar `syscall`?

- a) `rdi`
- b) `rsi`
- c) `rax`
- d) `rdx`

[RESOLVER AQUÍ: ]

---

**3.** ¿Qué sección usa `resb` para reservar memoria sin ocuparla en el binario?

- a) `.data`
- b) `.text`
- c) `.bss`
- d) `.rodata`

[RESOLVER AQUÍ: ]

---

**4.** ¿Qué valor de retorno trae `rax` después de un `sys_read`?

- a) 0 siempre
- b) La cantidad de bytes leídos realmente
- c) El tamaño del buffer
- d) El código de error

[RESOLVER AQUÍ: ]

---

**5.** En clase 3, ¿qué instrucción decide entre ELITE y NOVATO?

- a) `add`
- b) `inc`
- c) `cmp` + `jge`
- d) `sub`

[RESOLVER AQUÍ: ]

---

## B.2 — Verdadero o Falso con justificación (10 pts, 2 pts c/u)
> Marca V o F. Si es F, escribe la corrección. Una respuesta correcta sin justificación vale 1 pt.

**1.** `db` declara 8 bits (1 byte) por elemento de datos.
[RESOLVER AQUÍ: ]

V. db significa define byte: reserva 8 bits (1 byte) por cada elemento de datos.


**2.** `mov rax, 60` seguido de `syscall` es la forma estándar de terminar un programa en este curso.
[RESOLVER AQUÍ: ]

V. En este curso  un programa se termina con sys_exit: mov rax, 60, el codigo de salida en rdi y syscall. 


**3.** `resb 32` escribe 32 bytes de ceros en el binario.
[RESOLVER AQUÍ: ]

F. resb 32 solo reserva 32 bytes en .bss; no ocupan espacio en el archivo binario. El sistema los entrega inicializados en cero al cargar el programa.

**4.** En clase 2, el valor de `lon` (la longitud leída) viene de un `equ` fijo calculado por el ensamblador.
[RESOLVER AQUÍ: ]

F. lon sale de mov [lon], rax, es decir, del valor de retorno de read en tiempo de ejecucion. El equ se usa en los textos fijos, cuyo tamaño ya se conoce al ensamblar.


**5.** `add al, 48` convierte un dígito numérico (0–9) en su carácter ASCII imprimible.
[RESOLVER AQUÍ: ]

V. Los digitos '0' a '9' son los codigos ASCII 48 a 57; sumar 48 a un numero entre 0 y 9 da su caracter (3 + 48 = '3'). Solo sirve para un digito.

## B.3 — Lectura de código: predice la salida (6 pts)

Dado este fragmento (un programa mínimo y completo):

```asm
section .data
    msg db "HOLA", 10
    len equ $ - msg

section .text
    global _start
_start:[README.md](README.md)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall
    mov rax, 60
    mov rdi, 3
    syscall
```

1. ¿Qué imprime el programa? (2 pts)
2. ¿Con qué código de salida termina? ¿Qué significa ese código? (2 pts)
3. ¿Cuántas llamadas al kernel (`syscall`) hay? (2 pts)

[RESOLVER AQUÍ: ]

1. imprime HOLA seguido de un salto de linea (la cadena termina en 10).
2. termina con codigo 3 (mov rdi, 3). Por convencion 0 es exito y cualquier valor distinto de 0 indica error o una condicion especial; aqui el 3 es arbitrario y el proceso padre puede leerlo con echo $?.
3. hay 2 instrucciones syscall: una write y una exit.


## B.4 — Encuentra el error (4 pts)

El siguiente código **debería** imprimir `7` pero **no lo hace**. Encuentra el error, explícalo y escribe la línea corregida.

```asm
section .bss
    d resb 1

section .text
    global _start
_start:
    mov al, 7          ; el número a imprimir
    mov [d], al        ; guardar el carácter
    mov rax, 1
    mov rdi, 1
    mov rsi, d
    mov rdx, 1
    syscall
    mov rax, 60
    mov rdi, 0
    syscall
```

> Pista: el programa **debería** imprimir el carácter `7` en pantalla.
> ¿Qué byte está guardando realmente en `d`? ¿Qué instrucción de la
> clase 3 está ausente para que un número (0–9) se vuelva un carácter
> imprimible?

[RESOLVER AQUÍ: ]

`al` esta guardando el valor entero 7, que en codigo ASCII es un caracter no imprimible, para imprimir correctamente el entero 7, se debe convertir este al caracter ASCII al que equivale 7, para hacer esto se le debe agragar una linea debajo `de mov al,7`, de esta forma;

```
mov al, 7       ; el número a imprimir
add al, '0'     ; Convierte el 7 en a codigo ASCII (7) 
mov [d], al     ; guardar el carácter

```

---

## B.5 — Respuesta corta (10 pts, 2.5 pts c/u)

**1.** ¿Por qué en clase 2 se reserva `resb 32` para un nombre de "máximo 31 letras"?

[RESOLVER AQUÍ: ]
Porque, se necesita un byte mas para el salto de linea al final de la cadena
---

**2.** ¿Por qué la clase 2 quita el último byte (LF) del nombre antes de imprimirlo, usando `dec rax`?

[RESOLVER AQUÍ: ]
Esto se hace porque, la cadena ya viene con un salto de linea, y al hacer enter la consola agrega un salto de linea automaticamente, lo que causaria que hubiera un salto de linea doble. Entonces con `dec rax` se elimina ese ultimo byte que equivale a ese salto de linea

---

**3.** En clase 3, ¿por qué el programa valida FUE y AGI por separado (0–9) **y además** valida que la suma sea ≤ 9?

[RESOLVER AQUÍ: ]
Estos se validan por separado ya que se requiere estos atributos en momentos distintos, y se plantea que su suma sea menor a 9 porque este es el maximo de punto que el jugador puede repartir entre todas sus habilidades

---

**4.** ¿Qué significa `equ $ - etiqueta` y por qué es útil en vez de contar los bytes a mano?

[RESOLVER AQUÍ: ]
Esta es una manera de guardar valores en memoria sin especificar cuanto espacio se va a utilizar, este automaticamente cuenta los bytes de la informacion que se va a guardar en `etiqueta` y asi no hace falta especificar y contar los bytes manualmente. De esta manera cuando se quiera cambiar el valor de la variable por alguno mas corto o mas largo (En cantidad de bytes) este asigna automaticamente el espacio en memoria

---

## B.6 — Escribe el código (5 pts)

**1. (2 pts)** Escribe el bloque exacto (registros + `syscall`) para **imprimir la cadena**
`"FIN\n"` (con salto de línea) usando `sys_write`. Supón que la cadena está en la etiqueta `fin` y su longitud en `len_fin`.

[RESOLVER AQUÍ: ]
```
mov rax, 1
mov rdi, 1
mov rsi, fin
mov rdx, len_fin
syscall
```

---

**2. (3 pts)** Escribe las líneas de ensamblador para:

- Leer hasta **2 bytes** (1 dígito + el LF del Enter) desde el teclado en un buffer `b` (de `.bss`), usando `sys_read` — igual que la clase 3.
- Validar que sea un dígito entre `'0'` (48) y `'9'` (57); si no lo es, saltar a una etiqueta `.mal`.
- Si es dígito, convertirlo a número (restando 48) y guardarlo en la variable numérica `n` (1 byte, de `.bss`).

[RESOLVER AQUÍ: ]

```
    mov rax, 0
    mov rdi, 0 
    mov rsi, b
    mov rdx, 2
    syscall

    cmp byte [b], 48
    jb .mal
    cmp byte [b], 57
    ja .mal
    
    mov al, byte [b]
    sub al, 48
    mov [n], al
```

---

# RÚBRICA DE CALIFICACIÓN

| Sección | Tema | Puntos |
|---------|------|--------|
| A.1 | Clase 1: compilar, ejecutar, strace | 10 |
| A.2 | Clase 2: leer, buffer, modificación | 15 |
| A.3 | Clase 3: atributos, validación, modif. | 20 |
| A.4 | Crear desde cero | 15 |
| **Parte A** | **Práctica** | **60** |
| B.1 | Selección múltiple | 5 |
| B.2 | Verdadero/Falso (5 × 2) | 10 |
| B.3 | Predicción de salida (3 × 2) | 6 |
| B.4 | Encontrar el error (1 pregunta) | 4 |
| B.5 | Respuesta corta (4 × 2.5) | 10 |
| B.6 | Escribir código (2 + 3) | 5 |
| **Parte B** | **Teoría** | **40** |
| **TOTAL** | | **100** |

> **Nota final = (puntos obtenidos / 100) × 20.**
> Aprobación: ≥ 14/20 (es decir, ≥ 70% = 70 pts).

---

# CHECKLIST DE ENTREGA

Antes de entregar, verifica que tu carpeta `examen/` contenga:

- [ ] `clase-01/clase01.asm`, `clase-01/clase01` (binario), `clase-01/trace1.txt`
- [ ] `clase-02/clase02.asm` (modificado), `clase-02/clase02` (binario)
- [ ] `clase-03/clase03.asm` (modificado), `clase-03/clase03` (binario)
- [ ] `heroe.asm` y `heroe` (binario)
- [ ] `entrega.md` con todas las salidas y modificaciones pegadas
- [ ] Este `examen.md` con todos los bloques `[RESOLVER AQUÍ]` respondidos
- [ ] `strace` guardados donde se pidieron

**Recuerda:** el héroe del examen no es el que más rápido termina, sino el que
puede explicar cada línea que escribió.

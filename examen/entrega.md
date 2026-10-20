# Entrega.md

**Integrantes:** Esteban Aristizabal y  Julián Ladino

**Asignatura:** Fundamentos de Infraestructura

**Unidad:** Ensamblador x86-64 (NASM) — Clases 1, 2 y 3

---

# A.1 — El despertar (Clase 1)


## A.1.1 Compilación y ejecución


nasm -f elf64 clase01.asm -o clase01.o # ensamblar
ld clase01.o -o clase01 # enlazar
./clase01
echo $?
LA LEYENDA DEL REGISTRO v0.1
Bienvenido, heroe. Tu aventura empieza aqui.
El sistema operativo te despidio con elegancia.
Codigo de salida: 0


## A.2.3 Modificación obligatoria


section .data
titulo db "LA LEYENDA DEL REGISTRO v0.2", 10
len_titulo equ $ - titulo
pregunta db "Como se llama el heroe? (max 31 letras)", 10
len_pregunta equ $ - pregunta
saludo db "Que los dioses del reino te guien, heroe "
len_saludo equ $ - saludo
despedida db "Que tu leyenda nunca se borre del registro.", 10
len_despedida equ $ - despedida
salto db 10 ; un salto de linea suelto Salida con el nombre Gandalf:
LA LEYENDA DEL REGISTRO v0.2
Como se llama el heroe? (max 31 letras)
Que los dioses del reino te guien, heroe Gandalf
Que tu leyenda nunca se borre del registro.


# A.3 — Los atributos del héroe (Clase 3)



## A.3.1 Tabla [examen.md](examen.md)de las cinco combinaciones

| Caso | FUE | AGI | ¿ELITE o NOVATO o ERROR? | Código salida (`$?`) |
|------|-----|-----|--------------------------|----------------------|
| 1    | 3   | 5   | Elite   | 0   |
| 2    | 0   | 9   | Elite   | 0   |
| 3    | 9   | 9   | Error   | 1   |
| 4    | 0   | 0   | Novato   | 0   |
| 5    | `x` | 5   | Novato   | 0   |

## A.3.2 strace (FUE=8, AGI=2)

**Comando:**

```bash

strace -e trace=write,read,exit_group ./clase03

```

**Salida del strace:**

```
write(1, "LA LEYENDA DEL REGISTRO v0.3\n", 29LA LEYENDA DEL REGISTRO v0.3
) = 29
write(1, "Tienes 9 puntos para repartir. E"..., 62Tienes 9 puntos para repartir. El resto se vuelve vida (VID).
) = 62
write(1, "FUE (fuerza, 0 a 9): ", 21FUE (fuerza, 0 a 9): )   = 21
read(08
, "8\n", 2)                       = 2
write(1, "AGI (agilidad, 0 a 9): ", 23AGI (agilidad, 0 a 9): ) = 23
read(02
, "2\n", 2)                       = 2
write(1, "Error: no te alcanzan los 9 punt"..., 36Error: no te alcanzan los 9 puntos.
) = 36
+++ exited with 1 +++


```


## A.3.3 Modificación obligatoria: Ejercicio 1 (`.sin_fuerza`)



**Líneas agregadas:**

```asm
section .data
 sin_fuerza_msg db "Un heroe sin fuerza no es heroe.", 10 
len_sin_fuerza equ $ - sin_fuerza_msg

.puntos_ok:
    cmp byte [v_fue], 0
    je .sin_fuerza
    jmp .fin_sin_fuerza

.sin_fuerza:
    mov rax, 1
    mov rdi, 1
    mov rsi, sin_fuerza_msg
    mov rdx, len_sin_fuerza
    syscall

.fin_sin_fuerza:
    mov al, 9
    sub al, [v_used]
    mov [v_vid], al

```

**Salida completa con FUE=0, AGI=3:**

```

LA LEYENDA DEL REGISTRO v0.3
Tienes 9 puntos para repartir. El resto se vuelve vida (VID).
FUE (fuerza, 0 a 9): 0
AGI (agilidad, 0 a 9): 4
Un heroe sin fuerza no es heroe.
El heroe despierta como ELITE del reino.
FUE: 0
AGI: 4
VID: 5
Puntos gastados: 4
Nivel: 1
Los atributos quedaron grabados en los registros del heroe.

```



**Código de salida (`echo $?`):**

```
0
```
---

# A.4 — Crear desde cero (`heroe.asm`)

**Comandos de compilación y enlazado:**

```bash

nasm -f elf64 heroe.asm -o heroe.o

ld heroe.o -o heroe

./heroe

```

**Código completo de `heroe.asm`:**

```asm

section .data

    pregunta     db "Nombre: "
    pregunta_len  equ $ - pregunta

section .bss

    nombre resb 16

section .text

    global _start

_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, pregunta
    mov rdx, pregunta_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, nombre
    mov rdx, 16
    syscall

    dec rax
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, nombre
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

```



**Salida al ejecutar con el nombre `Sauron`:**

```

Nombre: Sauron
Sauron

```



**Código de salida (`echo $?`):**

```
echo $?
0

```
---

# Checklist de archivos en `examen/`



- [x] `clase-01/clase01.asm`, `clase-01/clase01` (binario), `clase-01/trace1.txt`

- [x] `clase-02/clase02.asm` (modificado), `clase-02/clase02` (binario)

- [x] `clase-03/clase03.asm` (modificado), `clase-03/clase03` (binario)

- [X] `heroe.asm` y `heroe` (binario)

- [x] `entrega.md` completo

- [x] `examen.md` con todos los bloques `[RESOLVER AQUÍ]` respondidos
```
---



# Checklist de archivos en `examen/`


- [x] `clase-01/clase01.asm`, `clase-01/clase01` (binario), `clase-01/trace1.txt`

- [x] `clase-02/clase02.asm` (modificado), `clase-02/clase02` (binario)

- [x] `clase-03/clase03.asm` (modificado), `clase-03/clase03` (binario)

- [x] `heroe.asm` y `heroe` (binario)

- [x] `entrega.md` completo

- [x] `examen.md` con todos los bloques `[RESOLVER AQUÍ]` respondidos

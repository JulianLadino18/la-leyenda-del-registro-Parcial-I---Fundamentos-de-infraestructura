# Entrega.md

**Integrantes:** Esteban, Tomás, Julián

**Asignatura:** Fundamentos de Infraestructura

**Unidad:** Ensamblador x86-64 (NASM) — Clases 1, 2 y 3

---

# A.1 — El despertar (Clase 1)


## A.1.1 Compilación y ejecución


**Comando de compilación:**

```bash

```



**Comando de enlazado:**

```bash

```



**Salida completa del programa:**

```

```



**Código de salida (`echo $?`):**

```

```



## A.1.2 strace


**Comando:**

```bash

strace -e trace=write,exit_group ./clase01 2> trace1.txt

```


**Salida del strace:**

```



```



---



# A.2 — El nombre del héroe (Clase 2)



## A.2.1 Tres nombres distintos



**Caso 1: nombre corto (≤ 5 letras)**



Nombre usado: 

```



```



**Caso 2: nombre de exactamente 31 letras**



Nombre usado: 

```



```



**Caso 3: nombre de 40 letras**



Nombre usado: 

```



```



## A.2.2 strace (nombre de 10 letras)



**Comando:**

```bash

strace -e trace=read,write ./clase02

```



**Salida del strace:**

```



```



## A.2.3 Modificación obligatoria



**Bloque `.data` modificado:**

```asm



```



**Salida con el nombre `Gandalf`:**

```



```



---



# A.3 — Los atributos del héroe (Clase 3)



## A.3.1 Tabla de las cinco combinaciones



| Caso | FUE | AGI | ¿ELITE, NOVATO o ERROR? | Código salida (`$?`) |

|------|-----|-----|-------------------------|----------------------|
| 1       | 3     | 5     | Elite                               | 0                               |
| 2       | 0     | 9     | Elite                               | 0                               |
| 3       | 9     | 9     | Error                             | 1                               |
| 4       | 0     | 0     | Novato                            | 0                               |
| 5       | `x`   | 5     | Novato                           | 0                               |
|------|-----|-----|-------------------------|----------------------|

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



```



**Código de salida (`echo $?`):**

```



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



- [ ] `clase-01/clase01.asm`, `clase-01/clase01` (binario), `clase-01/trace1.txt`

- [ ] `clase-02/clase02.asm` (modificado), `clase-02/clase02` (binario)

- [ ] `clase-03/clase03.asm` (modificado), `clase-03/clase03` (binario)

- [X] `heroe.asm` y `heroe` (binario)

- [-] `entrega.md` completo

- [ ] `examen.md` con todos los bloques `[RESOLVER AQUÍ]` respondidos
```



**Salida al ejecutar con el nombre `Sauron`:**

```



```



**Código de salida (`echo $?`):**

```



```



---



# Checklist de archivos en `examen/`



- [ ] `clase-01/clase01.asm`, `clase-01/clase01` (binario), `clase-01/trace1.txt`

- [ ] `clase-02/clase02.asm` (modificado), `clase-02/clase02` (binario)

- [ ] `clase-03/clase03.asm` (modificado), `clase-03/clase03` (binario)

- [ ] `heroe.asm` y `heroe` (binario)

- [ ] `entrega.md` completo

- [ ] `examen.md` con todos los bloques `[RESOLVER AQUÍ]` respondidos

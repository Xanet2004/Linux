# Linux - Xanet Zaldua

---

## Conceptos básicos

### Boot o P**roceso de arranque en Linux**

'¿Cuál es el proceso que se ejecuta o sigue el sistema al pulsar el botón de inicio?'

#### 1. Power-On Self Test (POST)

Se revisa si el estado del hardaware (Memoria RAM, Procesador...) es el correcto.

Si no hay errores, el sistema pasa al siguiente paso.

##### BIOS

El sistema que se encarga de inicializar el sistema y de ejecutar las funciones necesarias antes de dar paso al Sistema Operativo.

##### UEFI

Los ordenadores más actuales están utilizando UEFI en vez del BIOS. Es mejor en todos los aspectos y mayormente compatible.

##### UEFI vs BIOS

| Característica          | BIOS                                  | UEFI                                                  |
| ------------------------ | ------------------------------------- | ----------------------------------------------------- |
| Interfaz                 | Texto                                 | Gráfica                                              |
| Capacidad de arranque    | A través de MBR, máximo 2 TB       | A través de GPT, máximo 9.4 ZB                     |
| Velocidad                | Más lenta                            | Más rápida (puede usar Fast Boot)                   |
| Seguridad                | No tiene Secure Boot                  | Sí tiene Secure Boot                                 |
| Arquitectura de hardware | 16 bits                               | 32/64 bits                                            |
| Controladores            | Integrados en el firmware             | Puede cargar controladores desde el sistema operativo |
| Gestión de particiones  | MBR (máximo 4 particiones primarias) | GPT (máximo 128 particiones)                         |

#### 2. Cargar Boot Loader

##### BIOS

El BIOS trata de buscar un Boot Loader en el primer sector del disco de la memoria (512 bytes: Código para el proceso de inicialización + Tabla de particiones).

Si no se encuentra el Boot Loader, salta un error.

##### UEFI

UEFI trata de buscar los archivos EFI en la partición correspondiente de la memoria (Es por esto que al user UEFI tendremos que crear una partición específica para este).

El archivo del proceso de inicialización suele ser un grubx64.efi o un systemd-boot.

Se activa el GRUB y se le transfiere el control.

#### GRUB (GRand Unified Bootloader)

Cargan el KERNEL o el sistema operativo. Y el INITRD (Initial Ram Disk) o INITRAMFS (Initial Ram FileSystem).

##### Distintos Bootloaders

- GRUB --> El más usado en sistemas DEBIAN.
- LILO --> Más usado inicialmente en los Linux. Más limitado que GRUB.
- Windows Boot Manager --> Usado por los sistemas Windows.
- EFI Stub --> Bootloader para cuando se usa firmware de UEFI.

#### 4. Kernel de Linux

Se monta el sistema de ficheros de la raíz (/) y se carga el sistema de inicialización.

# Frontend - Gestión de Despachos y Ventas (Innovatech Chile)

Este repositorio contiene la aplicación de interfaz de usuario (Frontend) desarrollada en **React (Vite)** para Innovatech Chile. Su propósito es permitir a los administradores visualizar las órdenes de compra (Ventas) y generar las órdenes de despacho correspondientes.

## 🚀 Tecnologías Utilizadas
* **Framework:** React + Vite
* **Estilos:** TailwindCSS
* **Cliente HTTP:** Axios
* **Contenedorización:** Docker, NGINX
* **CI/CD:** GitHub Actions + AWS ECR + EC2

## 🏗️ Arquitectura y Contenedorización
El proyecto está contenerizado utilizando un **Dockerfile Multi-Stage**:
1. **Stage 1 (Build):** Utiliza Node.js (Alpine) para instalar dependencias y construir los archivos estáticos de React (`npm run build`).
2. **Stage 2 (Producción):** Utiliza un servidor web NGINX ultra ligero (Alpine) para servir los archivos estáticos. 

**Buenas prácticas aplicadas:**
* Ejecución de NGINX con un usuario no privilegiado (`USER 101`) para mayor seguridad.
* NGINX funciona además como **Reverse Proxy**, enrutando las peticiones seguras hacia el backend (`/api/v1/ventas` y `/api/v1/despachos`) para evitar errores de CORS y proteger los puertos del backend del acceso público.

## ⚙️ Configuración y Ejecución Local

Para levantar este proyecto localmente con Docker Compose:

1. Asegúrate de tener configurado el archivo `docker-compose.yml` en la raíz del proyecto.
2. Ejecuta el siguiente comando para construir y levantar el servicio:
   ```bash
   docker compose up -d --build front-despacho
   ```
3. La aplicación estará disponible en `http://localhost:80`.

> **Nota:** Las variables de entorno de las IPs de los backends (`VENTAS_IP` y `DESPACHOS_IP`) deben inyectarse para que el Reverse Proxy de NGINX sepa dónde redirigir el tráfico.

## 🔄 Pipeline CI/CD (Despliegue Continuo)
Este repositorio cuenta con un pipeline automatizado en **GitHub Actions**. Al hacer un push a la rama `deploy`:
1. Hace checkout del código.
2. Construye la imagen Docker (`innovatech-front-despacho`).
3. Sube la imagen a AWS ECR.
4. Ejecuta comandos de forma segura en la instancia EC2 utilizando **AWS Systems Manager (SSM)** para descargar la nueva imagen y reiniciar el contenedor de forma automática con zero-downtime, sin necesidad de abrir puertos SSH.

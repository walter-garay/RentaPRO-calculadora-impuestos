# RentaPRO - Calculadora de Impuestos a la Renta

RentaPRO es una aplicación web que permite calcular y simular el Impuesto a la Renta en Perú de manera interactiva y dinámica. Gracias a una interfaz moderna desarrollada con Laravel, Vue, Inertia, Tailwind CSS y Ant Design Vue, los usuarios pueden:

- Seleccionar el año de ejecución y visualizar el valor de la UIT y su decreto.
- Ingresar sus ingresos y retenciones de forma rápida y detallada.
- Calcular automáticamente la renta bruta, el total de retenciones y el límite anual para acceder a la suspensión de retenciones.
- Agregar, editar y eliminar registros de ingresos.

## Características

- **Año de ejecución y UIT:**  
  Selecciona el año (preseleccionado el actual, 2025) y se muestra el valor de la UIT correspondiente junto con su decreto. Si el usuario edita el valor UIT, el decreto deja de mostrarse.

- **Cálculo del límite anual:**  
  Se calcula el límite para la suspensión de retenciones con la fórmula:  
  \[
  \text{Límite anual} = (7 \times \text{UIT}) + (20\% \times (7 \times \text{UIT})) = 7 \times \text{UIT} \times 1.2
  \]  
  Por ejemplo, con UIT de S/ 5,350 en 2025, el límite sería aproximadamente S/ 44,940 (aunque SUNAT establece S/ 46,813, pudiendo incluir otros ajustes).

- **Ingreso de datos detallado:**  
  Permite ingresar ingresos de manera rápida con un input "Valor rápido" (formateado con prefijo y sufijo), además de poder desglosar, editar y borrar registros individualmente.

- **Diseño responsivo y moderno:**  
  Gracias a Tailwind CSS y Ant Design Vue, la aplicación tiene una interfaz limpia y adaptativa.

## Tecnologías utilizadas

- **Backend:** Laravel
- **Frontend:** Vue 3 con Inertia.js
- **Estilos:** Tailwind CSS
- **Componentes UI:** Ant Design Vue
- **Bundling:** Vite

## Instalación

1. **Clonar el repositorio:**

   ```bash
   git clone https://github.com/tu-usuario/RentaPRO.git
   cd RentaPRO

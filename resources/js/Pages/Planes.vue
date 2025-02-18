

  <script>
  import { Head } from '@inertiajs/vue3';


  </script>

<template>
    <Head title="Planes" />
    <div class="container">
      <h1 class="font-medium">Elige el plan adecuado para ti</h1>
      <p class="subtitulo">Todos los planes incluyen 14 días de prueba gratis</p>

      <div class="tarjetas-precios">
        <!-- Plan Gratis -->
        <div class="tarjeta">
          <h2 class="nombre-plan">Gratis</h2>
          <p class="titulo-seccion">Lo que Obtendrás</p>
          <ul class="caracteristicas">
            <li>Permite calcular el impuesto manualmente ingresando los datos básicos</li>
            <li>Acceso a una cantidad limitada de cálculos por mes</li>
            <li>No guarda historiales de cálculos</li>
          </ul>
          <div class="precio">
            S/. 0<span>/mes</span>
          </div>
          <button class="boton boton-secundario" @click="seleccionarPlan('gratis')">Elegir</button>
        </div>

        <!-- Plan Plus -->
        <div class="tarjeta destacado">
          <h2 class="nombre-plan">Plus</h2>
          <p class="titulo-seccion">Lo que Obtendrás</p>
          <ul class="caracteristicas">
            <li>Calculadora avanzada con más opciones</li>
            <li>Guarda el historial de cálculos</li>
            <li>Generación de reportes en PDF</li>
            <li>Soporte técnico por correo</li>
          </ul>
          <div class="precio">
            S/. 30<span>/mes</span>
          </div>
          <button class="boton boton-primario" @click="seleccionarPlan('plus')">Elegir</button>
        </div>

        <!-- Plan Premium -->
        <div class="tarjeta">
          <h2 class="nombre-plan">Profesional</h2>
          <p class="titulo-seccion">Lo que Obtendrás</p>
          <ul class="caracteristicas">
            <li>Todas las funciones del plan Plus</li>
            <li>Integración con sistemas contables o exportación a Excel</li>
            <li>Cálculos automáticos según normativas actualizadas</li>
            <li>Soporte técnico 24/7</li>
            <li>Personalización de informes</li>
          </ul>
          <div class="precio">
            S/. 120<span>/mes</span>
          </div>
          <button class="boton boton-secundario" @click="seleccionarPlan('premium')">Elegir</button>
        </div>
      </div>
    </div>
  </template>

  
  <style scoped>
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  }

  .container {
    max-width: 1200px;
    width: 100%;
    padding: 20px;
    margin: 0 auto;
  }

  h1 {
    text-align: center;
    margin-bottom: 10px;
    color: #1a1a1a;
    font-size: 28px;
  }

  .subtitulo {
    text-align: center;
    color: #666;
    margin-bottom: 40px;
  }

  .tarjetas-precios {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
  }

  .tarjeta {
    background: white;
    border-radius: 15px;
    padding: 25px;
    width: 300px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
  }

  .tarjeta:hover {
    transform: translateY(-5px);
  }

  .tarjeta.destacado {
    background: #1a1a3a;
    color: white;
  }

  .nombre-plan {
    font-size: 24px;
    margin-bottom: 20px;
    font-weight: 600;
  }

  .titulo-seccion {
    font-size: 14px;
    color: #666;
    margin-bottom: 15px;
  }

  .destacado .titulo-seccion {
    color: #ccc;
  }

  .caracteristicas {
    list-style: none;
    margin-bottom: 25px;
  }

  .caracteristicas li {
    margin-bottom: 12px;
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .caracteristicas li::before {
    content: "✓";
    color: #666;
  }

  .destacado .caracteristicas li::before {
    color: #fff;
  }

  .precio {
    font-size: 32px;
    font-weight: 700;
    margin-bottom: 20px;
  }

  .precio span {
    font-size: 16px;
    color: #666;
  }

  .destacado .precio span {
    color: #ccc;
  }

  .boton {
    width: 100%;
    padding: 12px;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  .boton-primario {
    background: #ff3366;
    color: white;
  }

  .boton-secundario {
    background: #f0f0f0;
    color: #ff3366;
  }

  .boton:hover {
    opacity: 0.9;
  }
  </style>

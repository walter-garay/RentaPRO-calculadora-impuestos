<script setup>
import { Head } from "@inertiajs/vue3";
import PublicLayout from "@/Layouts/PublicLayout.vue";
</script>

<template>
    <Head title="Planes" />
    <PublicLayout>
        <div class="container">
            <h1 class="font-medium">Elige el plan adecuado para ti</h1>
            <p class="subtitulo">
                Todos los planes incluyen 14 días de prueba gratis
            </p>

            <div class="tarjetas-precios">
                <!-- Plan Gratis -->
                <div class="tarjeta">
                    <h2 class="nombre-plan">Gratis</h2>
                    <p class="titulo-seccion">Lo que Obtendrás</p>
                    <ul class="caracteristicas">
                        <li>
                            Permite calcular el impuesto manualmente ingresando
                            los datos básicos
                        </li>
                        <li>
                            Acceso a una cantidad limitada de cálculos por mes
                        </li>
                        <li>No guarda historiales de cálculos</li>
                    </ul>
                    <div class="precio">S/. 0<span>/mes</span></div>
                    <a
                        class="boton boton-secundario"
                        href="https://wa.me/51934519338?text=Hola%2C%20me%20interesa%20el%20plan%20Gratis%20de%20RentaPRO.%20Por%20favor%20env%C3%ADame%20m%C3%A1s%20informaci%C3%B3n."
                        target="_blank"
                        rel="noopener"
                    >
                        Elegir
                    </a>
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
                    <div class="precio">S/. 15<span>/mes </span></div>
                    <a
                        class="boton boton-primario"
                        href="https://wa.me/51934519338?text=Hola%2C%20me%20interesa%20el%20plan%20Plus%20de%20RentaPRO.%20Por%20favor%20env%C3%ADame%20m%C3%A1s%20informaci%C3%B3n."
                        target="_blank"
                        rel="noopener"
                    >
                        Elegir
                    </a>
                </div>

                <!-- Plan Premium -->
                <div class="tarjeta">
                    <h2 class="nombre-plan">Profesional</h2>
                    <p class="titulo-seccion">Lo que Obtendrás</p>
                    <ul class="caracteristicas">
                        <li>Todas las funciones del plan Plus</li>
                        <li>
                            Integración con sistemas contables o exportación a
                            Excel
                        </li>
                        <li>
                            Cálculos automáticos según normativas actualizadas
                        </li>
                        <li>Soporte técnico 24/7</li>
                        <li>Personalización de informes</li>
                    </ul>
                    <div class="precio">S/. 40<span>/mes</span></div>
                    <a
                        class="boton boton-secundario"
                        href="https://wa.me/51934519338?text=Hola%2C%20me%20interesa%20el%20plan%20Profesional%20de%20RentaPRO.%20Por%20favor%20env%C3%ADame%20m%C3%A1s%20informaci%C3%B3n."
                        target="_blank"
                        rel="noopener"
                    >
                        Elegir
                    </a>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>

<style scoped>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
        sans-serif;
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
    gap: 32px;
    flex-wrap: wrap;
}

.tarjeta {
    background: #fff;
    border-radius: 18px;
    padding: 32px 28px 28px 28px;
    width: 320px;
    box-shadow: 0 6px 24px rgba(0, 0, 0, 0.08);
    transition: transform 0.2s, box-shadow 0.2s;
    display: flex;
    flex-direction: column;
    align-items: center;
    border: 2px solid transparent;
}

.tarjeta:hover {
    transform: translateY(-8px) scale(1.03);
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.13);
    border-color: #2563eb;
}

.tarjeta.destacado {
    background: linear-gradient(135deg, #2563eb 0%, #1a1a3a 100%);
    color: white;
    border-color: #2563eb;
}

.nombre-plan {
    font-size: 26px;
    margin-bottom: 18px;
    font-weight: 700;
    letter-spacing: 0.5px;
}

.titulo-seccion {
    font-size: 15px;
    color: #666;
    margin-bottom: 18px;
}

.destacado .titulo-seccion {
    color: #e0e7ff;
}

.caracteristicas {
    list-style: none;
    margin-bottom: 28px;
    padding-left: 0;
}

.caracteristicas li {
    margin-bottom: 13px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 15px;
}

.caracteristicas li::before {
    content: "✓";
    color: #2563eb;
    font-weight: bold;
}

.destacado .caracteristicas li::before {
    color: #fff;
}

.precio {
    font-size: 34px;
    font-weight: 800;
    margin-bottom: 22px;
    letter-spacing: 1px;
}

.precio span {
    font-size: 16px;
    color: #666;
}

.destacado .precio span {
    color: #e0e7ff;
}

.boton {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 8px;
    font-size: 17px;
    cursor: pointer;
    transition: background 0.2s, color 0.2s, box-shadow 0.2s;
    font-weight: 600;
    margin-top: 10px;
    box-shadow: 0 2px 8px rgba(37, 99, 235, 0.08);
}

.boton-primario {
    background: #2563eb;
    color: white;
}

.boton-primario:hover {
    background: #1d4ed8;
    color: #fff;
}

.boton-secundario {
    background: #f3f4f6;
    color: #2563eb;
    border: 1px solid #2563eb;
}

.boton-secundario:hover {
    background: #e0e7ff;
    color: #1a1a3a;
}

@media (max-width: 900px) {
    .tarjetas-precios {
        gap: 16px;
    }
    .tarjeta {
        width: 100%;
        min-width: 260px;
        max-width: 400px;
    }
}
</style>

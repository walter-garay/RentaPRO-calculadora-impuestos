<script setup>
import { Head } from "@inertiajs/vue3";
import PublicLayout from "@/Layouts/PublicLayout.vue";

defineProps({
    canLogin: {
        type: Boolean,
    },
    canRegister: {
        type: Boolean,
    },
    laravelVersion: {
        type: String,
        required: true,
    },
    phpVersion: {
        type: String,
        required: true,
    },
});

function handleImageError() {
    document.getElementById("screenshot-container")?.classList.add("!hidden");
    document.getElementById("docs-card")?.classList.add("!row-span-1");
    document.getElementById("docs-card-content")?.classList.add("!flex-row");
    document.getElementById("background")?.classList.add("!hidden");
}
</script>

<template>
    <Head>
        <title>Calculadora de Impuestos RentaPRO</title>
        <meta
            name="description"
            content="Calcula fácil y rápido tus impuestos de 4ta y 5ta categoría en Perú. Herramienta gratuita, precisa y moderna para trabajadores independientes y dependientes. Evita sorpresas y obtén tu informe al instante."
        />
        <meta
            name="keywords"
            content="calculadora impuestos, renta, Perú, 4ta categoría, 5ta categoría, declaración, SUNAT, trabajadores independientes, dependientes, UIT, deducciones, informe, online"
        />
        <meta property="og:title" content="Calculadora de Impuestos RentaPRO" />
        <meta
            property="og:description"
            content="Calcula tus impuestos de 4ta y 5ta categoría en Perú de forma sencilla y rápida. Herramienta gratuita y moderna."
        />
        <meta property="og:image" content="/images/logo.png" />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://tusitio.com/" />
        <link rel="icon" type="image/png" href="/images/logo.png" />
    </Head>
    <PublicLayout>
        <!-- Hero Section -->
        <main
            class="flex flex-col md:flex-row items-center justify-center text-center md:text-left px-4 md:px-20 gap-8 md:gap-10 w-full"
            style="min-height: calc(100vh - 80px)"
        >
            <!-- Texto -->
            <div
                class="w-full md:max-w-xl lg:max-w-2xl flex flex-col justify-center items-center md:items-start md:ml-20 md:mr-10"
                style="min-height: 400px"
            >
                <h1
                    class="text-4xl md:text-5xl font-bold text-gray-800 leading-tight mb-4"
                >
                    Renta anual en segundos
                </h1>
                <p class="mt-2 text-base md:text-lg text-gray-600 mb-6">
                    ¿Trabajas en una empresa o eres independiente? Descubre en
                    solo unos clics cuánto debes pagar en impuestos de 4ta y 5ta
                    categoría evitando sorpresas.
                    <strong>Fácil, rápido y sin complicaciones.</strong>
                </p>
                <a
                    href="/calculadora"
                    class="mt-2 inline-block px-8 py-4 text-base md:text-lg text-white font-bold bg-blue-600 rounded-md hover:bg-blue-700"
                >
                    Calcular ahora <i class="ri-arrow-right-line"></i>
                </a>
            </div>

            <!-- Imagen -->
            <div class="w-full flex justify-center items-center">
                <img
                    src="/images/tax.png"
                    alt="Simulación de renta anual"
                    class="w-full max-w-md md:max-w-xl lg:max-w-2xl"
                    style="min-width: 220px; min-height: 220px"
                />
            </div>
        </main>
        <!-- Sección ¿Cómo funciona? -->
        <section
            id="como-funciona"
            class="bg-white py-12 md:py-16 px-4 md:px-20 w-full"
        >
            <div class="max-w-5xl mx-auto text-center">
                <h2 class="text-2xl md:text-3xl font-bold mb-6 text-gray-800">
                    ¿Cómo funciona?
                </h2>
                <div class="flex flex-col md:flex-row items-center gap-8 mb-10">
                    <div class="w-full md:w-1/2 flex justify-center">
                        <img
                            src="/images/cap-calculadora.png"
                            alt="Vista de la calculadora"
                            class="rounded-lg shadow-lg w-full max-w-xs md:max-w-md lg:max-w-lg"
                        />
                    </div>
                    <div class="w-full md:w-1/2">
                        <div class="grid grid-cols-1 gap-6 text-left">
                            <div class="flex items-start gap-4">
                                <span
                                    class="inline-block bg-blue-100 text-blue-600 rounded-full p-3 text-2xl md:text-3xl font-bold"
                                    >1</span
                                >
                                <div>
                                    <p
                                        class="font-semibold mb-1 text-base md:text-lg"
                                    >
                                        Ingresa a la
                                        <a
                                            href="/calculadora"
                                            class="text-blue-600 underline hover:text-blue-800"
                                            >Calculadora</a
                                        >
                                    </p>
                                    <p
                                        class="text-gray-600 text-sm md:text-base"
                                    >
                                        Haz clic en el botón o en este
                                        <a
                                            href="/calculadora"
                                            class="text-blue-600 underline hover:text-blue-800"
                                            >enlace</a
                                        >
                                        para empezar.
                                    </p>
                                </div>
                            </div>
                            <div class="flex items-start gap-4">
                                <span
                                    class="inline-block bg-blue-100 text-blue-600 rounded-full p-3 text-2xl md:text-3xl font-bold"
                                    >2</span
                                >
                                <div>
                                    <p
                                        class="font-semibold mb-1 text-base md:text-lg"
                                    >
                                        Selecciona el año y valor de la UIT
                                    </p>
                                    <p
                                        class="text-gray-600 text-sm md:text-base"
                                    >
                                        Elige el año de ejercicio o ingresa el
                                        valor de la UIT si es personalizado.
                                    </p>
                                </div>
                            </div>
                            <div class="flex items-start gap-4">
                                <span
                                    class="inline-block bg-blue-100 text-blue-600 rounded-full p-3 text-2xl md:text-3xl font-bold"
                                    >3</span
                                >
                                <div>
                                    <p
                                        class="font-semibold mb-1 text-base md:text-lg"
                                    >
                                        Ingresa tus ingresos
                                    </p>
                                    <p
                                        class="text-gray-600 text-sm md:text-base"
                                    >
                                        Registra tus ingresos de 4ta y 5ta
                                        categoría, y tus gastos deducibles.
                                    </p>
                                </div>
                            </div>
                            <div class="flex items-start gap-4">
                                <span
                                    class="inline-block bg-blue-100 text-blue-600 rounded-full p-3 text-2xl md:text-3xl font-bold"
                                    >4</span
                                >
                                <div>
                                    <p
                                        class="font-semibold mb-1 text-base md:text-lg"
                                    >
                                        Calcula automáticamente
                                    </p>
                                    <p
                                        class="text-gray-600 text-sm md:text-base"
                                    >
                                        El sistema calcula tus impuestos,
                                        deducciones y te muestra un resumen
                                        claro.
                                    </p>
                                </div>
                            </div>
                            <div class="flex items-start gap-4">
                                <span
                                    class="inline-block bg-blue-100 text-blue-600 rounded-full p-3 text-2xl md:text-3xl font-bold"
                                    >5</span
                                >
                                <div>
                                    <p
                                        class="font-semibold mb-1 text-base md:text-lg"
                                    >
                                        Descarga tu informe
                                    </p>
                                    <p
                                        class="text-gray-600 text-sm md:text-base"
                                    >
                                        Obtén un informe descargable y
                                        recomendaciones para tu declaración
                                        anual.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </PublicLayout>
</template>

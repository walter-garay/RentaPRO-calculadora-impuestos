<script setup>
import { Head, Link } from '@inertiajs/vue3';

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
    document.getElementById('screenshot-container')?.classList.add('!hidden');
    document.getElementById('docs-card')?.classList.add('!row-span-1');
    document.getElementById('docs-card-content')?.classList.add('!flex-row');
    document.getElementById('background')?.classList.add('!hidden');
}
</script>

<template>
    <Head title="Welcome" />
    <div class="min-h-screen bg-gray-100">
        <!-- Navbar -->
        <header class="bg-white shadow-md py-4">
            <div class="container mx-auto flex justify-between items-center px-4">
                <!-- Logo -->
                <a href="#" class="text-xl font-bold text-gray-800 flex items-center justify-center space-x-2">
                    <img class="h-10" src="/images/logo.png" alt="">
                    <p>RentaPRO</p>

                </a>

                <!-- Links -->
                <nav class="hidden md:flex space-x-6">
                    <a href="#" class="text-gray-700 hover:text-blue-900 text-sm">¿Cómo funciona?</a>
                    <a href="#" class="text-gray-700 hover:text-blue-900 text-sm">Beneficios</a>
                    <a href="#" class="text-gray-700 hover:text-blue-900 text-sm">Soporte</a>
                </nav>

                <!-- Botones -->
                <nav v-if="canLogin" class="space-x-4">
                    <Link
                        v-if="$page.props.auth.user"
                        :href="route('dashboard')"
                        class="rounded-md px-3 py-2 text-black ring-1 ring-transparent transition hover:text-black/70 focus:outline-none focus-visible:ring-[#FF2D20] dark:text-white dark:hover:text-white/80 dark:focus-visible:ring-white"
                    >
                        Dashboard
                    </Link>

                    <template v-else>
                        <Link
                            :href="route('login')"
                            class="px-4 py-2 text-gray-600 border border-gray-400 rounded-md hover:bg-gray-200"
                        >
                            Iniciar sesión
                        </Link>

                        <Link
                            v-if="canRegister"
                            :href="route('register')"
                            class="px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700"
                        >
                            Registrarse
                        </Link>
                    </template>
                </nav>
            </div>
        </header>

        <!-- Hero Section -->
        <main class="min-h-[80vh] flex flex-col md:flex-row items-center justify-center text-center md:text-left px-8 md:px-20 gap-10 ms-24">
            <!-- Texto -->
            <div class="md:max-w-1/2 w-96">
                <h1 class="text-5xl font-bold text-gray-800 leading-tight">Renta anual en segundos</h1>
                <p class="mt-6 text-lg text-gray-600">
                    Descubre en solo unos clics cuánto debes pagar en impuestos de 4ta y 5ta categoría evitando sorpresas.
                    <strong>Fácil, rápido y sin complicaciones.</strong>
                </p>
                <a href="#" class="mt-8 inline-block px-8 py-4 text-lg text-white font-bold bg-blue-600 rounded-md hover:bg-blue-700">
                    Calcular ahora <i class="ri-arrow-right-line"></i>
                </a>
            </div>

            <!-- Imagen -->
            <div class="w-full md:w-1/2 flex justify-center">
                <img src="/images/tax.png" alt="Simulación de renta anual" class="w-[500px] md:w-[600px] max-w-full">
            </div>
        </main>
    </div>
</template>


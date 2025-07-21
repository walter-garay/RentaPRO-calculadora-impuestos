<script setup>
import { Head } from "@inertiajs/vue3";
import { ref } from "vue";

const menuOpen = ref(false);
function toggleMenu() {
    menuOpen.value = !menuOpen.value;
}
</script>

<template>
    <Head />
    <div class="min-h-screen bg-gray-100 flex flex-col">
        <!-- Navbar -->
        <header
            class="backdrop-blur-md bg-white/80 shadow-lg py-4 sticky top-0 z-30 transition-all duration-200"
        >
            <div
                class="container mx-auto flex justify-between items-center px-4 md:px-8"
            >
                <!-- Logo -->
                <a href="/" class="flex items-center space-x-3 group">
                    <img
                        class="h-11 w-11 rounded-lg shadow-md border border-blue-100 bg-white"
                        src="/images/logo.png"
                        alt="Logo RentaPRO"
                    />
                    <span
                        class="text-2xl font-extrabold  tracking-tight transition"
                        >RentaPRO</span
                    >
                </a>
                <!-- Desktop Links -->
                <nav class="hidden md:flex items-center space-x-8">
                    <a
                        href="/#como-funciona"
                        class="text-gray-700 hover:text-blue-700 text-base font-medium transition"
                        >¿Cómo funciona?</a
                    >
                    <a
                        href="/planes"
                        class="text-gray-700 hover:text-blue-700 text-base font-medium transition"
                        >Planes</a
                    >
                    <a
                        href="https://wa.me/51934519338?text=Hola%2C%20necesito%20soporte%20con%20RentaPRO"
                        target="_blank"
                        class="text-gray-700 hover:text-blue-700 text-base font-medium transition"
                        >Soporte</a
                    >
                </nav>
                <!-- Botón Calculadora desktop -->
                <nav class="hidden md:block ml-8">
                    <a
                        href="/calculadora"
                        class="px-5 py-2 text-base font-semibold text-white bg-blue-600 rounded-lg shadow hover:bg-blue-700 transition"
                        >Calculadora</a
                    >
                </nav>
                <!-- Hamburguesa móvil -->
                <button
                    @click="toggleMenu"
                    class="md:hidden flex items-center px-2 py-1 border rounded text-gray-700 border-gray-300 bg-white/70 shadow focus:outline-none transition"
                >
                    <svg
                        class="h-7 w-7"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M4 6h16M4 12h16M4 18h16"
                        />
                    </svg>
                </button>
            </div>
            <!-- Menú móvil -->
            <transition name="slide-fade">
                <div
                    v-if="menuOpen"
                    class="md:hidden bg-white/95 border-t border-gray-200 px-4 pb-4 pt-2 flex flex-col space-y-3 animate-fade-in-down shadow-lg rounded-b-xl"
                >
                    <a
                        href="/#como-funciona"
                        class="text-gray-700 hover:text-blue-700 text-base font-medium transition"
                        @click="menuOpen = false"
                        >¿Cómo funciona?</a
                    >
                    <a
                        href="/planes"
                        class="text-gray-700 hover:text-blue-700 text-base font-medium transition"
                        @click="menuOpen = false"
                        >Planes</a
                    >
                    <a
                        href="https://wa.me/51934519338?text=Hola%2C%20necesito%20soporte%20con%20RentaPRO"
                        target="_blank"
                        class="text-gray-700 hover:text-blue-700 text-base font-medium transition"
                        @click="menuOpen = false"
                        >Soporte</a
                    >
                    <a
                        href="/calculadora"
                        class="px-4 py-2 text-white bg-blue-600 rounded-lg shadow hover:bg-blue-700 text-center font-semibold transition"
                        @click="menuOpen = false"
                        >Calculadora</a
                    >
                </div>
            </transition>
        </header>
        <main class="flex-1 flex flex-col">
            <slot />
        </main>
    </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
.slide-fade-enter-active {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.slide-fade-enter-from {
    opacity: 0;
    transform: translateY(-16px);
}
.slide-fade-leave-active {
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
.slide-fade-leave-to {
    opacity: 0;
    transform: translateY(-8px);
}
@media (max-width: 768px) {
    header {
        padding-left: 0.5rem;
        padding-right: 0.5rem;
    }
}
</style>

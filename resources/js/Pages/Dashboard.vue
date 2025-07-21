<script setup>
import { Head } from "@inertiajs/vue3";
import PublicLayout from "@/Layouts/PublicLayout.vue";
import { ref, reactive, computed } from "vue";
import {
    PlusOutlined,
    EditOutlined,
    CheckOutlined,
    CloseOutlined,
} from "@ant-design/icons-vue";
import { cloneDeep } from "lodash-es";

const selectedYear = ref(2025);
const customUIT = ref("");
const showDetailed = ref(false);
const suspensionEnabled = ref(false);
const quickValue = ref(null);

// Array reactivo para ingresos detallados (Renta de 4ta Categoría).
const detailedIncomes = ref([]);
const count = ref(1);

// Objeto reactivo para almacenar el registro que se está editando (4ta Categoría).
const editableData = reactive({});

// Opciones de UIT
const uitOptions = [
    { year: 2025, value: 5350, decree: "D.S. N° 260-2024-EF" },
    { year: 2024, value: 5150, decree: "D.S. N° 309-2023-EF" },
    { year: 2023, value: 4950, decree: "D.S. N° 309-2022-EF" },
    { year: 2022, value: 4600, decree: "D.S. N° 398-2021-EF" },
    { year: 2021, value: 4400, decree: "D.S. N° 392-2020-EF" },
    { year: 2020, value: 4300, decree: "D.S. N° 380-2019-EF" },
    { year: 2019, value: 4200, decree: "D.S. N° 298-2018-EF" },
    { year: 2018, value: 4150, decree: "D.S. N° 380-2017-EF" },
    { year: 2017, value: 4050, decree: "D.S. N° 353-2016-EF" },
    { year: 2016, value: 3950, decree: "D.S. N° 397-2015-EF" },
    { year: 2015, value: 3850, decree: "D.S. N° 374-2014-EF" },
    { year: 2014, value: 3800, decree: "D.S. N° 304-2013-EF" },
];

const selectedUIT = computed(() => {
    if (selectedYear.value === "otro") {
        return customUIT.value
            ? {
                  year: "otro",
                  value: Number(customUIT.value),
                  decree: "Personalizado",
              }
            : null;
    }
    return uitOptions.find((opt) => opt.year === selectedYear.value);
});

// Límite anual (4ta categoría)
const incomeLimit = computed(() => {
    if (!selectedYear.value) return 0;
    const selectedOption = uitOptions.find(
        (opt) => opt.year === selectedYear.value
    );
    if (!selectedOption) return 0;
    return (selectedOption.value * 7) / (1 - 0.2); // Ajuste para suspensión.
});

// Recalcular retenciones 4ta
const refreshRetentions = () => {
    if (suspensionEnabled.value) {
        let cumulative = 0;
        detailedIncomes.value.forEach((item) => {
            const currentVal = Number(item.value) || 0;
            if (cumulative < incomeLimit.value) {
                if (cumulative + currentVal <= incomeLimit.value) {
                    item.retention = 0;
                } else {
                    item.retention = parseFloat((currentVal * 0.08).toFixed(2));
                }
            } else {
                item.retention = parseFloat((currentVal * 0.08).toFixed(2));
            }
            cumulative += currentVal;
        });
    } else {
        detailedIncomes.value.forEach((item) => {
            const currentVal = Number(item.value) || 0;
            item.retention =
                currentVal > 1500
                    ? parseFloat((currentVal * 0.08).toFixed(2))
                    : 0;
        });
    }
    // Actualiza ingresos en edición.
    Object.keys(editableData).forEach((key) => {
        updateEditableRetention(key);
    });
};

const addIncome = () => {
    const newKey = `${count.value}`;
    count.value++;
    let val = quickValue.value || 0;
    detailedIncomes.value.push({
        key: newKey,
        description: `Recibo #${newKey}`,
        value: val,
        retention: 0,
    });
    quickValue.value = null;
    refreshRetentions();
};

const edit = (key) => {
    const row = detailedIncomes.value.find((item) => item.key === key);
    if (row) {
        editableData[key] = cloneDeep(row);
    }
};

const updateEditableRetention = (key) => {
    const index = detailedIncomes.value.findIndex((item) => item.key === key);
    if (index === -1) return;

    const temp = detailedIncomes.value.map((item) => ({ ...item }));
    temp[index].value = Number(editableData[key].value) || 0;

    let cumulative = 0;
    let newRetention = 0;
    for (let i = 0; i < temp.length; i++) {
        const currentVal = Number(temp[i].value) || 0;
        if (suspensionEnabled.value) {
            if (cumulative < incomeLimit.value) {
                if (cumulative + currentVal <= incomeLimit.value) {
                    if (i === index) newRetention = 0;
                } else {
                    if (i === index)
                        newRetention = parseFloat(
                            (currentVal * 0.08).toFixed(2)
                        );
                }
            } else {
                if (i === index)
                    newRetention = parseFloat((currentVal * 0.08).toFixed(2));
            }
            cumulative += currentVal;
        } else {
            if (i === index) {
                newRetention =
                    currentVal > 1500
                        ? parseFloat((currentVal * 0.08).toFixed(2))
                        : 0;
            }
        }
    }
    editableData[key].retention = newRetention;
};

const save = (key) => {
    const index = detailedIncomes.value.findIndex((item) => item.key === key);
    if (index > -1) {
        detailedIncomes.value[index] = { ...editableData[key] };
        refreshRetentions();
        delete editableData[key];
    }
};

const onDelete = (key) => {
    detailedIncomes.value = detailedIncomes.value.filter(
        (item) => item.key !== key
    );
    refreshRetentions();
};

const totalIncome = computed(() => {
    return detailedIncomes.value.reduce(
        (sum, item) => sum + (Number(item.value) || 0),
        0
    );
});

const totalRetentions = computed(() => {
    return detailedIncomes.value.reduce(
        (sum, item) => sum + (Number(item.retention) || 0),
        0
    );
});

// -------------------------
// RENTA DE 5TA CATEGORÍA (PLANILLA)
// -------------------------
const showMonthlyBreakdown = ref(false);
const annualSalary5ta = ref("");
const monthlySalaries = ref(Array(12).fill(""));
const months = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre",
];

const computedAnnualSalary5ta = computed(() => {
    return monthlySalaries.value.reduce((sum, s) => sum + (Number(s) || 0), 0);
});

// Límite anual (7 UIT) para 5ta
const annualLimit5ta = computed(() => {
    return selectedUIT.value ? selectedUIT.value.value * 7 : 0;
});

// Monto retenido (5ta): (Rem. Anual - 7UIT) * 0.08 (si excede)
const withheldAmount5ta = computed(() => {
    let annualRemuneration = 0;
    if (showMonthlyBreakdown.value) {
        annualRemuneration = computedAnnualSalary5ta.value;
    } else {
        annualRemuneration = Number(annualSalary5ta.value) || 0;
    }
    const limit = annualLimit5ta.value;
    if (annualRemuneration > limit) {
        return parseFloat(((annualRemuneration - limit) * 0.08).toFixed(2));
    }
    return 0;
});

// Renta Bruta 5ta (total)
const rentaBruta5ta = computed(() => {
    if (showMonthlyBreakdown.value) {
        return computedAnnualSalary5ta.value;
    }
    return Number(annualSalary5ta.value) || 0;
});

// -------------------------
// GASTOS DEDUCIBLES (3 UIT)
// -------------------------
const deductibleExpensesData = ref([
    {
        key: 1,
        category: "Arrendamiento o subarrendamiento",
        annualSpending: 0,
        deductionRate: 0.3,
    },
    {
        key: 2,
        category: "Hoteles y restaurantes",
        annualSpending: 0,
        deductionRate: 0.15,
    },
    {
        key: 3,
        category: "Servicios de cuarta categoría de médicos y odontólogos",
        annualSpending: 0,
        deductionRate: 0.3,
    },
    {
        key: 4,
        category: "Aportación ESSALUD Trabajadores del Hogar",
        annualSpending: 0,
        deductionRate: 1.0,
    },
    {
        key: 5,
        category: "Por prestación de artes, oficios y actividades",
        annualSpending: 0,
        deductionRate: 0.3,
    },
]);

// Límite de 3 UIT para gastos deducibles
const limit3UIT = computed(() => {
    return selectedUIT.value ? selectedUIT.value.value * 3 : 0;
});

// Suma de los importes deducibles de cada categoría (sin aplicar el tope)
const totalValueToDeductRaw = computed(() => {
    return deductibleExpensesData.value.reduce((acc, row) => {
        const partial = (Number(row.annualSpending) || 0) * row.deductionRate;
        return acc + partial;
    }, 0);
});

// Monto total a deducir (aplicando el tope de 3 UIT)
const finalDeduction = computed(() => {
    const raw = totalValueToDeductRaw.value;
    return parseFloat(Math.min(raw, limit3UIT.value).toFixed(2));
});

// -------------------------
// CAMPOS EDITABLES EN EL CARD FINAL
// -------------------------
const otrasRentas = ref("");
const itf = ref("");
const rentaExtranjera = ref("");

// Cálculos para la tarjeta final
const rentaBruta4ta = computed(() => totalIncome.value); // tomado de 4ta
const deduccion20PorCiento = computed(() => {
    // Límite 24 UIT
    const maxDeducible = selectedUIT.value ? selectedUIT.value.value * 24 : 0;
    const base = rentaBruta4ta.value * 0.2;
    return base > maxDeducible ? maxDeducible : parseFloat(base.toFixed(2));
});
const rentaNeta4ta = computed(() => {
    return parseFloat(
        (rentaBruta4ta.value - deduccion20PorCiento.value).toFixed(2)
    );
});

// Total 4ta + 5ta
const total4ta5ta = computed(() => {
    // Suma de renta neta 4ta + renta bruta 5ta + otras rentas
    return parseFloat(
        (
            rentaNeta4ta.value +
            rentaBruta5ta.value +
            Number(otrasRentas.value || 0)
        ).toFixed(2)
    );
});

const deduccion7UIT = computed(() => {
    return selectedUIT.value ? selectedUIT.value.value * 7 : 0;
});
const gastosDeducibles = computed(() => finalDeduction.value);

// Total renta neta (trabajo)
const totalRentaNeta = computed(() => {
    // total4ta5ta - deducción 7 UIT - gastos deducibles
    const result =
        total4ta5ta.value - deduccion7UIT.value - gastosDeducibles.value;
    return result > 0 ? parseFloat(result.toFixed(2)) : 0;
});

// Renta imponible (trabajo + extranjera)
const totalRentaImponible = computed(() => {
    const base = totalRentaNeta.value + Number(rentaExtranjera.value || 0);
    return parseFloat(base.toFixed(2));
});

// -------------------------
// CÁLCULO PROGRESIVO POR TRAMOS
// -------------------------
const bracketCalculation = computed(() => {
    // Definición de tramos en UIT
    const bracketDefs = [
        { limitUIT: 5, rate: 0.08 }, // Hasta 5 UIT
        { limitUIT: 20, rate: 0.14 }, // Exceso de 5 UIT hasta 20 UIT
        { limitUIT: 35, rate: 0.17 }, // Exceso de 20 UIT hasta 35 UIT
        { limitUIT: 45, rate: 0.2 }, // Exceso de 35 UIT hasta 45 UIT
        { limitUIT: Infinity, rate: 0.3 }, // Exceso de 45 UIT
    ];

    if (!selectedUIT.value) return [];
    const uitVal = selectedUIT.value.value;
    const total = totalRentaImponible.value;

    const results = [];
    for (let i = 0; i < bracketDefs.length; i++) {
        const bracketLimitSoles = bracketDefs[i].limitUIT * uitVal;
        const bracketRate = bracketDefs[i].rate;
        let segment = 0;

        if (i === 0) {
            // Primer tramo: desde 0 hasta bracketLimitSoles
            segment = Math.min(total, bracketLimitSoles);
        } else {
            // Tramos siguientes: desde el límite anterior hasta el actual
            const prevLimitSoles = bracketDefs[i - 1].limitUIT * uitVal;
            if (total > prevLimitSoles) {
                segment = Math.min(total, bracketLimitSoles) - prevLimitSoles;
            }
        }

        if (segment <= 0) break;

        const segmentTax = segment * bracketRate;

        // Label de alcance
        let rangeLabel = "";
        if (i === 0) {
            rangeLabel = `Hasta ${bracketDefs[i].limitUIT} UIT`;
        } else if (bracketDefs[i].limitUIT === Infinity) {
            rangeLabel = `Exceso de ${bracketDefs[i - 1].limitUIT} UIT`;
        } else {
            rangeLabel = `Exceso de ${bracketDefs[i - 1].limitUIT} UIT hasta ${
                bracketDefs[i].limitUIT
            } UIT`;
        }

        results.push({
            alcance: rangeLabel,
            tasa: (bracketRate * 100).toFixed(0) + "%",
            tramo: segment.toFixed(2),
            impuesto: segmentTax.toFixed(2),
        });
    }

    return results;
});

// Impuesto total (suma de todos los tramos)
const totalImpuesto = computed(() => {
    return bracketCalculation.value
        .reduce((sum, item) => {
            return sum + parseFloat(item.impuesto);
        }, 0)
        .toFixed(2);
});

// -------------------------
// IMPUESTOS A REGULARIZAR
// -------------------------
const saldoFavorAnterior = ref(0);
const pagosCuentaCuarta = ref(0);

// Retenciones calculadas
const retencionesCuarta = computed(() => totalRetentions.value); // 4ta
const retencionesQuinta = computed(() => withheldAmount5ta.value); // 5ta

// Impuesto final a regularizar
const impuestoRegularizar = computed(() => {
    const totalRet =
        Number(saldoFavorAnterior.value) +
        Number(pagosCuentaCuarta.value) +
        retencionesCuarta.value +
        retencionesQuinta.value;
    return parseFloat((totalImpuesto.value - totalRet).toFixed(2));
});

// -------------------------
// DESCARGAR INFORME
// -------------------------
function descargarInforme() {
    // Construimos un texto con la información más relevante.
    const info = `
INFORME DE CÁLCULO DE IMPUESTOS

Año de ejercicio: ${selectedYear.value}
Valor UIT: ${selectedUIT.value ? selectedUIT.value : "No definido"}

--- RENTA DE 4TA CATEGORÍA ---
Renta Bruta 4ta: ${rentaBruta4ta.value}
Deducción 20% (máx. 24 UIT): ${deduccion20PorCiento.value}
Renta Neta 4ta: ${rentaNeta4ta.value}

--- RENTA DE 5TA CATEGORÍA ---
Renta Bruta 5ta: ${rentaBruta5ta.value}
Retenciones 5ta: ${withheldAmount5ta.value}

--- OTRAS RENTAS ---
Otras Rentas: ${otrasRentas.value || 0}

--- GASTOS DEDUCIBLES (3 UIT) ---
Gastos deducibles: ${gastosDeducibles.value}

--- TOTAL RENTA NETA DE TRABAJO ---
Total Renta Neta (4ta + 5ta - 7 UIT - gastos): ${totalRentaNeta.value}
Renta Extranjera: ${rentaExtranjera.value || 0}
Renta Imponible: ${totalRentaImponible.value}

--- IMPUESTO POR TRAMOS ---
${bracketCalculation.value
    .map(
        (b, idx) =>
            `Tramo ${idx + 1}: ${b.alcance} => ${b.tramo} soles a ${
                b.tasa
            } => Impuesto: S/. ${b.impuesto}`
    )
    .join("\n")}

Impuesto total (suma de tramos): S/. ${totalImpuesto.value}

--- IMPUESTOS A REGULARIZAR ---
Saldo a favor anterior: S/. ${saldoFavorAnterior.value}
Pagos a cuenta 4ta: S/. ${pagosCuentaCuarta.value}
Retenciones 4ta: S/. ${retencionesCuarta.value}
Retenciones 5ta: S/. ${retencionesQuinta.value}

Impuesto final a regularizar: S/. ${impuestoRegularizar.value}
`;

    // Creamos un Blob con el contenido y generamos un enlace de descarga
    const blob = new Blob([info], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "informe-impuestos.txt"; // Nombre del archivo
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
}
</script>

<template>
    <Head title="Calculadora de impuestos a la renta 4ta y 5ta categoría" />
    <PublicLayout>
        <div class="py-8">
            <div class="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
                <!-- Tarjeta: Selección de UIT (Año de ejercicio) -->
                <div class="bg-white shadow-sm sm:rounded-lg p-6">
                    <div
                        class="flex flex-wrap gap-4 items-start justify-between"
                    >
                        <div
                            class="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-4"
                        >
                            <h2 class="text-xl font-semibold text-gray-900">
                                Año de ejercicio
                            </h2>
                            <a-select
                                v-model:value="selectedYear"
                                class="max-w-xs"
                                size="normal"
                            >
                                <a-select-option value="otro"
                                    >Otro</a-select-option
                                >
                                <a-select-option
                                    v-for="option in uitOptions"
                                    :key="option.year"
                                    :value="option.year"
                                >
                                    {{ option.year }}
                                </a-select-option>
                            </a-select>
                        </div>
                        <div
                            v-if="selectedUIT"
                            class="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-4 sm:mt-0"
                        >
                            <p class="font-semibold">UIT</p>
                            <a-input
                                :value="selectedUIT.value"
                                disabled
                                class="w-40"
                            >
                                <template #prefix>S/.</template>
                                <template #suffix>soles</template>
                            </a-input>
                            <span class="text-gray-600">{{
                                selectedUIT.decree
                            }}</span>
                        </div>
                        <a-input
                            v-if="selectedYear === 'otro'"
                            v-model:value="customUIT"
                            placeholder="Ingrese valor de UIT"
                            class="w-40 mt-2"
                            type="number"
                            min="0"
                        />
                    </div>
                </div>

                <!-- Grid responsive -->
                <div class="grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-4">
                    <!-- Columna izquierda: 4ta, 5ta y Gastos deducibles -->
                    <div class="space-y-6">
                        <!-- Tarjeta: Renta de 4ta categoría (RxH) -->
                        <div class="bg-white shadow-sm sm:rounded-lg p-6">
                            <h2 class="text-xl font-semibold text-gray-900">
                                Renta de 4ta categoría (RxH)
                            </h2>
                            <p class="text-gray-700 mt-2">
                                La renta de cuarta categoría corresponde a los
                                ingresos obtenidos por el trabajo independiente
                                de profesionales, técnicos y otros trabajadores
                                independientes que emiten recibos por
                                honorarios.
                            </p>

                            <!-- Campos de ingresos totales -->
                            <div class="mt-4 space-y-4">
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium"
                                        >Renta bruta</span
                                    >
                                    <a-input
                                        :value="totalIncome"
                                        disabled
                                        class="w-40"
                                    >
                                        <template #prefix>S/.</template>
                                        <template #suffix>soles</template>
                                    </a-input>
                                </div>
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium"
                                        >Retención total</span
                                    >
                                    <a-input
                                        :value="totalRetentions"
                                        disabled
                                        class="w-40"
                                    >
                                        <template #prefix>S/.</template>
                                        <template #suffix>soles</template>
                                    </a-input>
                                </div>
                                <!-- Campo: Límite anual (4ta categoría) -->
                                <div
                                    v-if="selectedYear"
                                    class="flex items-center space-x-4"
                                >
                                    <span class="text-gray-900 font-medium">
                                        Límite anual
                                    </span>
                                    <a-input
                                        :value="incomeLimit"
                                        disabled
                                        class="w-40"
                                    >
                                        <template #prefix>S/.</template>
                                        <template #suffix>soles</template>
                                    </a-input>
                                </div>
                            </div>

                            <!-- Botón para mostrar/ocultar detalles -->
                            <a-button
                                type="link"
                                class="mt-4"
                                @click="showDetailed = !showDetailed"
                            >
                                {{
                                    showDetailed
                                        ? "Ocultar detalles"
                                        : "Desglosar ingresos"
                                }}
                            </a-button>

                            <!-- Sección detallada para 4ta categoría -->
                            <div v-if="showDetailed" class="mt-4">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-2">
                                        <a-button
                                            type="primary"
                                            @click="addIncome"
                                        >
                                            <PlusOutlined /> Agregar ingreso
                                        </a-button>
                                        <!-- Ingreso rápido -->
                                        <a-input
                                            v-model:value="quickValue"
                                            type="number"
                                            class="w-40"
                                            placeholder="0"
                                        >
                                            <template #prefix>S/.</template>
                                            <template #suffix>soles</template>
                                        </a-input>
                                    </div>
                                    <div class="flex items-center space-x-2">
                                        <span class="text-gray-900"
                                            >Suspensión de retención (8%)</span
                                        >
                                        <a-switch
                                            v-model:checked="suspensionEnabled"
                                            @change="refreshRetentions"
                                        />
                                    </div>
                                </div>

                                <!-- Tabla editable para 4ta categoría -->
                                <a-table
                                    :dataSource="detailedIncomes"
                                    :columns="[
                                        {
                                            title: 'Descripción',
                                            dataIndex: 'description',
                                            key: 'description',
                                            width: 120,
                                        },
                                        {
                                            title: 'Valor (S/)',
                                            dataIndex: 'value',
                                            key: 'value',
                                            width: 100,
                                        },
                                        {
                                            title: 'Retención (S/)',
                                            dataIndex: 'retention',
                                            key: 'retention',
                                            width: 120,
                                        },
                                        {
                                            title: '',
                                            dataIndex: 'operation',
                                            key: 'operation',
                                            width: 60,
                                        },
                                    ]"
                                    :pagination="false"
                                    bordered
                                    class="mt-4"
                                    :scroll="{ x: true }"
                                >
                                    <template #bodyCell="{ column, record }">
                                        <!-- Columna Descripción -->
                                        <template
                                            v-if="
                                                column.dataIndex ===
                                                'description'
                                            "
                                        >
                                            <div class="editable-cell relative">
                                                <div
                                                    v-if="
                                                        editableData[record.key]
                                                    "
                                                    class="editable-cell-input-wrapper"
                                                >
                                                    <a-input
                                                        v-model:value="
                                                            editableData[
                                                                record.key
                                                            ].description
                                                        "
                                                        @pressEnter="
                                                            save(record.key)
                                                        "
                                                        class="w-full"
                                                    />
                                                    <CheckOutlined
                                                        class="editable-cell-icon-check absolute right-0 top-1/2 transform -translate-y-1/2 cursor-pointer"
                                                        @click="
                                                            save(record.key)
                                                        "
                                                    />
                                                </div>
                                                <div
                                                    v-else
                                                    class="editable-cell-text-wrapper"
                                                >
                                                    <span>{{
                                                        record.description
                                                    }}</span>
                                                    <EditOutlined
                                                        class="editable-cell-icon absolute right-0 top-1/2 transform -translate-y-1/2 cursor-pointer"
                                                        @click="
                                                            edit(record.key)
                                                        "
                                                    />
                                                </div>
                                            </div>
                                        </template>

                                        <!-- Columna Valor -->
                                        <template
                                            v-else-if="
                                                column.dataIndex === 'value'
                                            "
                                        >
                                            <div class="editable-cell relative">
                                                <div
                                                    v-if="
                                                        editableData[record.key]
                                                    "
                                                    class="editable-cell-input-wrapper"
                                                >
                                                    <a-input-number
                                                        v-model:value="
                                                            editableData[
                                                                record.key
                                                            ].value
                                                        "
                                                        @change="
                                                            updateEditableRetention(
                                                                record.key
                                                            )
                                                        "
                                                        @pressEnter="
                                                            save(record.key)
                                                        "
                                                        class="w-full"
                                                    />
                                                    <CheckOutlined
                                                        class="editable-cell-icon-check absolute right-0 top-1/2 transform -translate-y-1/2 cursor-pointer"
                                                        @click="
                                                            save(record.key)
                                                        "
                                                    />
                                                </div>
                                                <div
                                                    v-else
                                                    class="editable-cell-text-wrapper"
                                                >
                                                    <span>{{
                                                        record.value
                                                    }}</span>
                                                    <EditOutlined
                                                        class="editable-cell-icon absolute right-0 top-1/2 transform -translate-y-1/2 cursor-pointer"
                                                        @click="
                                                            edit(record.key)
                                                        "
                                                    />
                                                </div>
                                            </div>
                                        </template>

                                        <!-- Columna Retención -->
                                        <template
                                            v-else-if="
                                                column.dataIndex === 'retention'
                                            "
                                        >
                                            <span>{{ record.retention }}</span>
                                        </template>

                                        <!-- Columna para borrar -->
                                        <template
                                            v-else-if="
                                                column.dataIndex === 'operation'
                                            "
                                        >
                                            <a-popconfirm
                                                title="¿Seguro de eliminar?"
                                                @confirm="
                                                    () => onDelete(record.key)
                                                "
                                            >
                                                <a-button
                                                    type="link"
                                                    size="small"
                                                >
                                                    <CloseOutlined />
                                                </a-button>
                                            </a-popconfirm>
                                        </template>
                                    </template>
                                </a-table>
                            </div>
                        </div>

                        <!-- Tarjeta: Renta de 5ta categoría (Planilla) -->
                        <div class="bg-white shadow-sm sm:rounded-lg p-6">
                            <h2 class="text-xl font-semibold text-gray-900">
                                Renta de 5ta categoría (Planilla)
                            </h2>
                            <p class="text-gray-700 mt-2">
                                Ingrese su remuneración anual o desglose su
                                sueldo mensual. El monto retenido se calculará
                                como (Remuneración anual – 7 UIT) * 0.08.
                            </p>

                            <div class="mt-4 space-y-4">
                                <!-- Opción para desglosar sueldo mensual -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium"
                                        >Desglosar sueldo por mes</span
                                    >
                                    <a-switch
                                        v-model:checked="showMonthlyBreakdown"
                                    />
                                </div>
                                <!-- Remuneración anual -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium"
                                        >Remuneración anual</span
                                    >
                                    <template v-if="!showMonthlyBreakdown">
                                        <a-input
                                            v-model:value="annualSalary5ta"
                                            placeholder="Ingrese remuneración anual"
                                            class="w-40"
                                            type="number"
                                        >
                                            <template #prefix>S/.</template>
                                        </a-input>
                                    </template>
                                    <template v-else>
                                        <a-input
                                            :value="computedAnnualSalary5ta"
                                            disabled
                                            class="w-40"
                                        >
                                            <template #prefix>S/.</template>
                                        </a-input>
                                    </template>
                                </div>
                                <!-- Sueldos mensuales (solo si se desglosa) -->
                                <div
                                    v-if="showMonthlyBreakdown"
                                    class="grid grid-cols-3 gap-4"
                                >
                                    <div
                                        v-for="(month, index) in months"
                                        :key="month"
                                        class="flex items-center space-x-2"
                                    >
                                        <span class="text-gray-900"
                                            >{{ month }}:</span
                                        >
                                        <a-input-number
                                            v-model:value="
                                                monthlySalaries[index]
                                            "
                                            placeholder="0"
                                            class="w-32"
                                            type="number"
                                        >
                                            <template #prefix>S/.</template>
                                        </a-input-number>
                                    </div>
                                </div>
                                <!-- Límite anual (7 UIT) -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium"
                                        >Límite anual (7 UIT)</span
                                    >
                                    <a-input
                                        :value="annualLimit5ta"
                                        disabled
                                        class="w-40"
                                    >
                                        <template #prefix>S/.</template>
                                    </a-input>
                                </div>
                                <!-- Monto retenido -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium"
                                        >Monto retenido</span
                                    >
                                    <a-input
                                        :value="withheldAmount5ta"
                                        disabled
                                        class="w-40"
                                    >
                                        <template #prefix>S/.</template>
                                    </a-input>
                                </div>
                            </div>
                        </div>

                        <!-- Tarjeta: Gastos deducibles (límite de 3 UIT) -->
                        <div class="bg-white shadow-sm sm:rounded-lg p-6">
                            <h2 class="text-xl font-semibold text-gray-900">
                                Gastos deducibles (límite 3 UIT)
                            </h2>
                            <p class="text-gray-700 mt-2">
                                Ingrese los montos anuales de gastos en cada
                                categoría. Se aplica el porcentaje indicado a
                                cada uno, y la suma total de deducciones no
                                podrá exceder 3 UIT.
                            </p>

                            <a-table
                                :dataSource="deductibleExpensesData"
                                :columns="[
                                    {
                                        title: 'Categoría',
                                        dataIndex: 'category',
                                        key: 'category',
                                        width: 180,
                                    },
                                    {
                                        title: 'Gasto total anual (S/)',
                                        dataIndex: 'annualSpending',
                                        key: 'annualSpending',
                                        width: 220,
                                    },
                                    {
                                        title: 'Porcentaje a deducir',
                                        dataIndex: 'deductionRate',
                                        key: 'deductionRate',
                                        width: 120,
                                    },
                                    {
                                        title: 'Valor a deducir (S/)',
                                        dataIndex: 'valueToDeduct',
                                        key: 'valueToDeduct',
                                        width: 120,
                                    },
                                ]"
                                :pagination="false"
                                bordered
                                class="mt-4"
                                :scroll="{ x: true }"
                            >
                                <template #bodyCell="{ column, record }">
                                    <!-- Categoría -->
                                    <template
                                        v-if="column.dataIndex === 'category'"
                                    >
                                        {{ record.category }}
                                    </template>

                                    <!-- Gasto total anual (editable) -->
                                    <template
                                        v-else-if="
                                            column.dataIndex ===
                                            'annualSpending'
                                        "
                                    >
                                        <a-input-number
                                            v-model:value="
                                                record.annualSpending
                                            "
                                            placeholder="0"
                                            class="w-full"
                                        >
                                            <template #prefix>S/.</template>
                                        </a-input-number>
                                    </template>

                                    <!-- Porcentaje a deducir -->
                                    <template
                                        v-else-if="
                                            column.dataIndex === 'deductionRate'
                                        "
                                    >
                                        {{ record.deductionRate * 100 }}%
                                    </template>

                                    <!-- Valor a deducir (parcial, sin el tope) -->
                                    <template
                                        v-else-if="
                                            column.dataIndex === 'valueToDeduct'
                                        "
                                    >
                                        {{
                                            (
                                                (record.annualSpending || 0) *
                                                record.deductionRate
                                            ).toFixed(2)
                                        }}
                                    </template>
                                </template>
                            </a-table>

                            <!-- Monto total a deducir, considerando el tope de 3 UIT -->
                            <div class="mt-4 flex items-center space-x-4">
                                <span class="text-gray-900 font-medium">
                                    Monto total a deducir (máx. 3 UIT)
                                </span>
                                <a-input
                                    :value="finalDeduction"
                                    disabled
                                    class="w-40"
                                >
                                    <template #prefix>S/.</template>
                                </a-input>
                            </div>
                        </div>
                    </div>

                    <!-- Columna derecha (más angosta): Card "Cálculo de impuestos" -->
                    <div class="space-y-6">
                        <!-- Card: Cálculo de impuestos -->
                        <div class="bg-white shadow-sm sm:rounded-lg p-6">
                            <h2 class="text-xl font-semibold text-gray-900">
                                Cálculo de impuestos
                            </h2>
                            <!-- Alinear horizontalmente los campos en un grid de 2 columnas -->
                            <div class="mt-4 grid grid-cols-1 gap-4">
                                <!-- Renta Bruta 4ta -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >Renta Bruta 4ta</span
                                    >
                                    <a-input
                                        :value="rentaBruta4ta"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Deducción 20% (máx 24 UIT) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium">
                                        Deducción 20% (máx 24 UIT)
                                    </span>
                                    <a-input
                                        :value="deduccion20PorCiento"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Renta Neta 4ta -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >Renta Neta 4ta</span
                                    >
                                    <a-input
                                        :value="rentaNeta4ta"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Total Renta 5ta (bruta) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >Renta 5ta</span
                                    >
                                    <a-input
                                        :value="rentaBruta5ta"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Otras Rentas (4ta o 5ta) (Editable) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >Otras Rentas</span
                                    >
                                    <a-input
                                        v-model:value="otrasRentas"
                                        class="w-40"
                                    />
                                </div>

                                <!-- Total Rentas de 4ta y 5ta (sumado) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >Total 4ta + 5ta</span
                                    >
                                    <a-input
                                        :value="total4ta5ta"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Deducción 7 UIT -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >Deducción 7 UIT</span
                                    >
                                    <a-input
                                        :value="deduccion7UIT"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Gastos deducibles (3 UIT) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium">
                                        Gastos deducibles
                                    </span>
                                    <a-input
                                        :value="gastosDeducibles"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- ITF (Editable) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >ITF</span
                                    >
                                    <a-input v-model:value="itf" class="w-40" />
                                </div>

                                <!-- Total Renta Neta de Trabajo -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium"
                                        >Total Renta Neta</span
                                    >
                                    <a-input
                                        :value="totalRentaNeta"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Renta de fuente extranjera (Editable) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium">
                                        Renta extranjera
                                    </span>
                                    <a-input
                                        v-model:value="rentaExtranjera"
                                        class="w-40"
                                    />
                                </div>

                                <!-- Total renta imponible (calculado) -->
                                <div
                                    class="flex items-center space-x-4 justify-between"
                                >
                                    <span class="text-gray-900 font-medium">
                                        Renta imponible
                                    </span>
                                    <a-input
                                        :value="totalRentaImponible"
                                        disabled
                                        class="w-40"
                                    />
                                </div>
                            </div>
                        </div>

                        <!-- Card: Renta imponible (Detalle de tramos e impuesto) -->
                        <div class="bg-white shadow-sm sm:rounded-lg p-6">
                            <h2 class="text-xl font-semibold text-gray-900">
                                Renta imponible
                            </h2>

                            <!-- Tabla de tramos -->
                            <a-table
                                :dataSource="bracketCalculation"
                                :columns="[
                                    {
                                        title: 'Alcance',
                                        dataIndex: 'alcance',
                                        key: 'alcance',
                                        width: 140,
                                    },
                                    {
                                        title: 'Tasa',
                                        dataIndex: 'tasa',
                                        key: 'tasa',
                                        width: 80,
                                    },
                                    {
                                        title: 'Tramo (S/)',
                                        dataIndex: 'tramo',
                                        key: 'tramo',
                                        width: 120,
                                    },
                                    {
                                        title: 'Impuesto (S/)',
                                        dataIndex: 'impuesto',
                                        key: 'impuesto',
                                        width: 120,
                                    },
                                ]"
                                :pagination="false"
                                bordered
                                class="mt-4"
                                :scroll="{ x: true }"
                            />

                            <!-- Total de impuestos (suma de los tramos) -->
                            <div class="mt-4 flex items-center space-x-4">
                                <span class="text-gray-900 font-medium">
                                    Total de impuestos
                                </span>
                                <a-input
                                    :value="totalImpuesto"
                                    disabled
                                    class="w-40"
                                >
                                    <template #prefix>S/.</template>
                                </a-input>
                            </div>
                        </div>

                        <!-- Card: Impuestos a regularizar -->
                        <div class="bg-white shadow-sm sm:rounded-lg p-6">
                            <h2 class="text-xl font-semibold text-gray-900">
                                Impuestos a regularizar
                            </h2>
                            <div class="mt-4 space-y-4">
                                <!-- Saldo a favor del ejercicio anterior (Editable) -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium">
                                        Saldo a favor del ejercicio anterior
                                    </span>
                                    <a-input
                                        v-model:value="saldoFavorAnterior"
                                        class="w-40"
                                    />
                                </div>

                                <!-- Pagos a cuenta por cuarta categoría (Editable) -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium">
                                        Pagos a cuenta por cuarta categoría
                                    </span>
                                    <a-input
                                        v-model:value="pagosCuentaCuarta"
                                        class="w-40"
                                    />
                                </div>

                                <!-- Retenciones por cuarta categoría (No editable) -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium">
                                        Retenciones por cuarta categoría (RxH)
                                    </span>
                                    <a-input
                                        :value="retencionesCuarta"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Retenciones por quinta categoría (Planilla) (No editable) -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium">
                                        Retenciones por quinta categoría
                                        (Planilla)
                                    </span>
                                    <a-input
                                        :value="retencionesQuinta"
                                        disabled
                                        class="w-40"
                                    />
                                </div>

                                <!-- Impuesto final a regularizar -->
                                <div class="flex items-center space-x-4">
                                    <span class="text-gray-900 font-medium">
                                        Impuesto final a regularizar
                                    </span>
                                    <a-input
                                        :value="impuestoRegularizar"
                                        disabled
                                        class="w-40"
                                    />
                                </div>
                            </div>
                        </div>

                        <!-- Botón para descargar informe -->
                        <div class="flex justify-end font-medium">
                            <a-button type="primary" @click="descargarInforme">
                                Descargar informe
                            </a-button>
                        </div>
                    </div>
                </div>
                <!-- Fin de las dos columnas -->
            </div>
        </div>
    </PublicLayout>
</template>

<style scoped>
.editable-cell {
    position: relative;
    padding-right: 24px;
}
.editable-cell-input-wrapper,
.editable-cell-text-wrapper {
    padding-right: 24px;
}
.editable-cell-icon,
.editable-cell-icon-check {
    right: 0;
    width: 20px;
    cursor: pointer;
}
.editable-cell-icon {
    display: none;
}
.editable-cell:hover .editable-cell-icon {
    display: inline-block;
}
</style>

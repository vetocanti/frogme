<template>
    <div>
        <button @click="previousPage" :disabled="currentPage === 1">Anterior</button>
        <span>{{ currentPage }}  de {{ totalPage }}</span>
        <button @click="nextPage" :disabled="currentPage >= totalPage">Siguiente</button>
    </div>
</template>

<script>
    export default {
    props: ['currentPage', 'totalPage', 'totalItemsPerPage'],
    methods: {
        previousPage() {
            if (this.currentPage > 1) {
                this.$emit('page-changed', this.currentPage - 1);
            }
        },
        nextPage() {
            if (this.currentPage < this.totalPage) {
                this.$emit('page-changed', this.currentPage + 1);
            }
        }
    }
};
</script>

<style scoped>

    button {
        padding: 5px 10px;
        margin: 5px;
        background-color: seagreen;
        border: 1px solid #ccc;
        cursor: pointer;
        color: white;
        border-radius: 10px;
    }

    button:hover {
        background-color: #4CAF50;

    }

    button:disabled {
        background-color: #ccc;
        cursor: not-allowed;
    }

    span {
        margin: 0 10px;
    }

    div {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 1vh;
        position: relative;
        bottom: 0;
    }
    

</style>
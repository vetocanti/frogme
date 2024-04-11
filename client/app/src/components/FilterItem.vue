<template>
    <div class="col">
        <h2>Filtrar por tipo de sismo</h2>
        <div class="filter">
                <h3>Tipo de sismo seleccionado</h3>
                <li v-for="filter in selectedFilters" :key="filter">
                    {{ filter }}
                    <button class="filter-button" @click="removeFilter(filter)">X</button>
                </li>                
                <div class="type-filter" v-if="filters.length!==1">
                    <h3>Tipos de sismo</h3>
                    <select id="filter" v-model="selectedFilter">
                        <option v-for="filter in filters" :key="filter" :value="filter">{{ filter }}</option>
                    </select>
                </div>

                <label for="itemPerPage">Cantidad:</label>
                <input id="itemPerPage" v-model="itemsPerPage" type="number" >
            <button @click="applyFilter">Apply</button>

        </div>
    </div>
</template>

<script>
import Swal from 'sweetalert2'
export default {
    props: ['initialItemsPerPage', 'typeFilter'],
    data() {
    return {
        itemsPerPage: this.initialItemsPerPage,
        selectedFilter: 'Elegir tipo de sismo',
        selectedFilters: [],
        filters: ['Elegir tipo de sismo','md', 'ml', 'ms', 'mw', 'me', 'mi', 'mb', 'mlg']
    };
},
    watch: {
    selectedFilter(newFilter) {
        if (newFilter && newFilter !== 'Elegir tipo de sismo') {
            this.selectedFilters.push(newFilter);
            this.filters = this.filters.filter(filter => filter !== newFilter);
        }
        this.selectedFilter = 'Elegir tipo de sismo'; // Reset the selected filter to the placeholder
    }
},
methods: {
    removeFilter(filter) {
        this.selectedFilters = this.selectedFilters.filter(f => f !== filter);
        this.filters.push(filter);
        this.$emit('filter-changed', this.selectedFilters, this.itemsPerPage === undefined ? 10 : this.itemsPerPage)
    },
    applyFilter() {
    if(this.itemsPerPage>1000){
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'La cantidad de sismos a mostrar no puede ser mayor a 1000',
        })
        return;
    }
    this.$emit('filter-changed', this.selectedFilters, this.itemsPerPage === undefined ? 10 : this.itemsPerPage)
}
}

}
</script>

<style scoped>
    .col {
        display: flex;
        justify-content: center;
        flex-direction: column;
        align-items: center;
        padding-top: calc(5% + 8vh);
    }
    h3 {
        padding: 0.5rem;
        font-size: 14px;
        font-weight: 600;
        text-align: center;
        justify-content: center;
        height: 32px;
    }

    .filter {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
        margin: auto 0 auto 0;
    }
    .type-filter {
        display: flex;
        flex-direction: row;

    }
    label {
        margin-right: 1rem;
        font-size: 14px;
        font-weight: 600;
        height: 32px;
    }

    input{
        width: 7%;
        padding: 0.5rem;
        border-radius: 10px;
        border: 1px solid seagreen;
    }
    select {
        padding: 0.5rem;
        margin: 20px;
        width: fit-content;
        background-color: seagreen;
        color: white;
        border: olivedrab;
        border-radius: 10px;
    }
    option {
        padding: 0.5rem;
        color: white;
    }
    li {
        padding: 0.5rem;
        margin: 0.5rem;
        list-style-type: none;
        background-color:seagreen;
        border-radius:10px ;
        color: white;
    }
    button {
        padding: 0.5rem;
        margin: 0.5rem;
        background-color: seagreen;
        color: white;
        border: none;
        border-radius: 10px;
    }

    .filter-button {
        padding: 0;
        margin: 0;
    }

    @media screen and (max-width: 750px){
    
        .col {
            padding-top: 30vh;
        }
        .filter {
            flex-direction: column;
        }

        input {
            width: 40%;
        }
    }
</style>
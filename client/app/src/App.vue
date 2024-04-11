<script>
import axios from 'axios';
import PaginatorItem from './components/PaginatorItem.vue';
import TableItem from './components/TableItem.vue';
import HeaderItem from './components/HeaderItem.vue';
import FilterItem from './components/FilterItem.vue';

export default {
    components: {
        PaginatorItem,
        TableItem,
        HeaderItem, 
        FilterItem
    },
    data() {
        return {
            currentPage: 1,
            totalItemPerPage: 10,
            totalPage:0,
            items: [],
            total: 0, 
            itemsPerPage: 10,
            selectedFilters: [],
            isLoad: false,
        };
    },
    methods: {
        handlePageChange(newPage) {
            this.currentPage = newPage;
            console.log('Page changed to', newPage);
            this.isLoad = false;
            this.fetchData();
        },
        applyFilter(filters, itemsPerPage) {
        this.selectedFilters = filters;
        this.itemsPerPage = itemsPerPage;
        this.isLoad = false;
        this.fetchData();
    },
        fetchData() {
            axios.get('http://127.0.0.1:3000/api/features', {
                params: {
                    page: this.currentPage,
                    per_page: this.itemsPerPage,
                    mag_type: this.selectedFilters
                }
            })
            .then(response => {
                this.items = response.data.data;
                console.log(response.data);
                this.total = response.data.pagination.total;
                this.totalPage =  Math.ceil(this.total / this.itemsPerPage);     
                this.isLoad = true;
            })
            .catch(error => {
              console.error('There was an error!', error);
                // Handle the error here
            });
        }
    },
    created() {
        this.fetchData();
    },
    watch: {
        isLoad: function(val) {
            if (val) {
                this.$nextTick(() => {
                    this.$forceUpdate();
                });
            }
        }
    }
};
</script>

<template>
    <HeaderItem></HeaderItem>
    <div v-if="isLoad">
        <FilterItem :selectedFilters="selectedFilters" :itemsPerPage="itemsPerPage" @filter-changed="applyFilter" ></FilterItem>
        <TableItem :items="items"></TableItem>
        <PaginatorItem :currentPage="currentPage" :totalPage="totalPage" @page-changed="handlePageChange"></PaginatorItem>
        
    </div>
    <div v-else>
        <div class="spinner-border" role="status">
            <span class="sr-only">Cargando...</span>
        </div>
    </div>

  </template>

<style scoped>

.spinner-border {
    width: 3rem;
    height: 3rem;
    align-items: center;
    justify-content: center;
    display: flex;
    color: seagreen;
    position: absolute;
    top: 40%;
    right: 50%;
    font-size: 2rem;
}
</style>
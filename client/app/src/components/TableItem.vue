<template>
    <table >
        <thead>
            <tr>
                <th>Magnitud</th>
                <th>Lugar</th>
                <th>Tiempo</th>
                <th>url</th>
                <th>Tsunami</th>
                <th>Tipo de Maginitud</th>
                <th>Latitud</th>
                <th>Longitud</th>
                <th>Acción</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="item in items" :key="item.id">
                <td>{{ item.attributes.magnitude }}</td>
                <td>{{ item.attributes.place }}</td>
                <td>{{ item.attributes.time }}</td>
                <td><a :href="item.links.external_url" target="_blank">Link</a></td>
                <td>{{ item.attributes.tsunami == true ? 'Sí': 'No' }}</td>
                <td>{{ item.attributes.mag_type }}</td>
                <td>{{ item.attributes.coordinates.latitude }}</td>
                <td>{{ item.attributes.coordinates.longitude }}</td>
                <td><button @click="AddComment(item.id)">Comentar</button></td>
            </tr>
        </tbody>
    </table>
    
</template>

<script>
import axios from 'axios';
import Swal from 'sweetalert2';
export default {
    name: 'TableItem',
    props: {
        items: {
            type: Array,
            required: true
        },
    },


    methods: {
        AddComment(id) {
            Swal.fire({
                title: 'Comentar',
                input: 'text',
                inputLabel: 'Comentario',
                inputPlaceholder: 'Escribe tu comentario',
                showCancelButton: true,
                confirmButtonText: 'Enviar',
                cancelButtonText: 'Cancelar',
                showLoaderOnConfirm: true,
                preConfirm: (comment) => {
                    return axios.post('http://127.0.0.1:3000/api/features/' + id + '/comments', {
                        body: comment
                    })
                .then(response => {
                    if (response.status === 201) {
                        Swal.fire({
                            title: 'Comentario enviado',
                            icon: 'success'
                        });
                    } else {
                        Swal.fire({
                            title: 'Error',
                            text: 'Hubo un error al enviar el comentario',
                            icon: 'error'
                        });
                    }
                })
                .catch(error => {
                    Swal.fire({
                        title: 'Error',
                        text: 'Hubo un error al enviar el comentario',
                        icon: 'error'
                    });
                    console.error('There was an error!', error);
                });
            }


                })
            
        },
                },    
};
</script>

<style scoped>
    table {
        position: relative;
        top: calc(10%+15vh);
        width: 100%;
        border-collapse: collapse;
    }
    th {
        background-color: #f2f2f2;
    }
    th, td {
        border: 1px solid #f2f2f2;
        padding: 8px;
        text-align: left;
    }
    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    tr:hover {
        background-color: #f2f2f2;
    }

    @media (max-width: 600px) {
        table {
            width: 100%;
        }
    }
</style>
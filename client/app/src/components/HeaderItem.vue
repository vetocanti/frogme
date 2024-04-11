<script setup>
// import menu from '../assets/menu.svg';
import logo from '../assets/logo.png';
// const onClick = () => {
//     const menu = document.getElementById('menu');
//     if (menu.style.display === 'none') {
//         menu.style.display = 'flex';
//     } else {
//         menu.style.display = 'none';
//     }
// }

</script>

<template>
    <div class="nav-bar">
        <img :src="logo" height="100" width="150">
        <h1>Sismos pasado 30 días</h1>
    </div>
</template>

<style scoped>
.nav-bar {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 1rem;
    background-color: #333;
    color: seagreen;
    position: fixed; /* Changed from relative to fixed */
    z-index: 1;
    width: 100%;
    top: 0; /* Added to position at the top of the page */
    background-color:whitesmoke;
}

.nav-bar img {
    margin-right: 10%;
    margin-left: 5% ;
}
.nav-bar nav {
    display: flex;
    flex-direction: row;
    gap: 1rem;
}
.nav-bar a {
    color: white;
    text-decoration: none;
}

.nav-bar a:hover {
    color:brown;
    font-weight: 700;
}


</style>

<template>
  <header class="fixed top-0 left-0 right-0 z-50">
    <nav class="bg-gradient-to-r from-indigo-600 to-blue-500 shadow-lg">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <!-- Left side: Logo and Title -->
          <div class="flex items-center">
            <NuxtLink to="/" class="flex items-center">
              <svg 
                class="h-8 w-8 text-white" 
                viewBox="0 0 24 24" 
                fill="none" 
                stroke="currentColor"
              >
                <path 
                  stroke-linecap="round" 
                  stroke-linejoin="round" 
                  stroke-width="2" 
                  d="M13 10V3L4 14h7v7l9-11h-7z"
                />
              </svg>
              <h1 class="ml-2 text-xl font-semibold text-white">My poetry corner</h1>
            </NuxtLink>
          </div>
          <!-- Right side: Navigation -->
          <div class="flex items-center">
            <NuxtLink 
              v-if="user" 
              to="/admin" 
              class="text-gray-600 hover:text-gray-900 px-3 py-2"
            >
              Admin
            </NuxtLink>
            <button 
              v-if="user"
              @click="handleLogout" 
              class="text-gray-600 hover:text-gray-900 px-3 py-2"
            >
              Logout
            </button>
            <NuxtLink 
              v-else 
              to="/login" 
              class="text-gray-600 hover:text-gray-900 px-3 py-2"
            >
              Login
            </NuxtLink>
          </div>
        </div>
      </div>
    </nav>
    <NuxtLoadingIndicator />
    <NuxtPage />
  </header>
</template>

<script setup>
const user = useSupabaseUser()
const client = useSupabaseClient()
const router = useRouter()

const handleLogout = async () => {
  try {
    await client.auth.signOut()
    await navigateTo('/login')
  } catch (error) {
    console.error('Logout error:', error)
  }
}

// Handle auth state changes
watchEffect(() => {
  if (process.client) {
    client.auth.onAuthStateChange((event, session) => {
      if (event === 'SIGNED_OUT') {
        router.push('/login')
      }
    })
  }
})
</script>

<style scoped>
/* Optional: Add any additional custom styles here */
</style>
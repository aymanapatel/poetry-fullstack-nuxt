<template>
  <div class="min-h-screen bg-gray-50">
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <NuxtLink to="/" class="flex items-center px-2 text-gray-900 font-semibold">
              My Poetry Corner
            </NuxtLink>
          </div>
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
  </div>
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
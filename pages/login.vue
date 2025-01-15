<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          {{ isLogin ? 'Sign in to your account' : 'Create new account' }}
        </h2>
      </div>
      <form class="mt-8 space-y-6" @submit.prevent="handleSubmit">
        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <label for="email-address" class="sr-only">Email address</label>
            <input
              id="email-address"
              v-model="email"
              name="email"
              type="email"
              required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
              placeholder="Email address"
            />
          </div>
          <div>
            <label for="password" class="sr-only">Password</label>
            <input
              id="password"
              v-model="password"
              name="password"
              type="password"
              required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
              placeholder="Password"
            />
          </div>
        </div>

        <div class="flex items-center justify-between">
          <button
            type="button"
            class="text-sm text-indigo-600 hover:text-indigo-500"
            @click="isLogin = !isLogin"
          >
            {{ isLogin ? 'Need an account? Sign up' : 'Already have an account? Sign in' }}
          </button>
        </div>

        <div>
          <button
            type="submit"
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {{ isLogin ? 'Sign in' : 'Sign up' }}
          </button>
        </div>

        <div v-if="error" class="text-red-600 text-sm text-center">
          {{ error }}
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const email = ref('')
const password = ref('')
const isLogin = ref(true)
const error = ref('')

const handleSubmit = async () => {
  error.value = ''
  try {
    if (isLogin.value) {
      const { error: signInError } = await client.auth.signInWithPassword({
        email: email.value,
        password: password.value
      })
      if (signInError) throw signInError
      navigateTo('/admin')
    } else {
      const { data, error: signUpError } = await client.auth.signUp({
        email: email.value,
        password: password.value,
      })
      if (signUpError) throw signUpError
      alert('Account created successfully! Please sign in.')
      isLogin.value = true
      console.log('@@@', data)
      if (data.url) {
        redirect(data.url) // use the redirect API for your server framework
      }
    }
  } catch (err) {
    error.value = err.message
  }
}
</script>
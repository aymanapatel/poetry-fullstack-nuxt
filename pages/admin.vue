<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Add New Poem</h1>
    <form @submit.prevent="handleSubmit" class="max-w-2xl space-y-6">
      <div>
        <label for="title" class="block text-sm font-medium text-gray-700">Title</label>
        <input
          type="text"
          id="title"
          v-model="form.title"
          required
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        />
      </div>

      <div>
        <label for="author" class="block text-sm font-medium text-gray-700">Author</label>
        <input
          type="text"
          id="author"
          v-model="form.author"
          required
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        />
      </div>

      <div>
        <label for="content" class="block text-sm font-medium text-gray-700">Content</label>
        <textarea
          id="content"
          v-model="form.content"
          rows="10"
          required
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        ></textarea>
      </div>

      <button
        type="submit"
        class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
      >
        Add Poem
      </button>
    </form>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()

// Redirect if not authenticated
if (!user.value) {
  navigateTo('/login')
}

const form = reactive({
  title: '',
  author: '',
  content: ''
})

const handleSubmit = async () => {
  try {
    console.log('>>>', client.auth.getUser())
    const { error } = await client
      .from('poems')
      .insert([
        {
          title: form.title,
          author: form.author,
          content: form.content,
          user_id: user.value?.id
        }
      ])
    
    if (error) throw error

    // Reset form
    form.title = ''
    form.author = ''
    form.content = ''

    alert('Poem added successfully!')
  } catch (error) {
    alert(error.message)
  }
}
</script>
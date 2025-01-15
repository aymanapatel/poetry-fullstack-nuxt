<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <h1 class="text-4xl font-bold text-gray-900 mb-8 text-center">Featured Poems</h1>
    <div v-if="pending" class="text-center py-12">
      <p class="text-gray-600">Loading poems...</p>
    </div>
    <div v-else-if="error" class="text-center py-12">
      <p class="text-red-600">{{ error.message }}</p>
    </div>
    <div v-else class="grid gap-8 md:grid-cols-2 lg:grid-cols-3 poem-container ">
      <div v-for="poem in poems" :key="poem.id" class="p-6 rounded-lg shadow-md poem-card vintage">
        <h2 class="poem-title font-poetry">{{ poem.title }}</h2>
        <p class="poem-author">by {{ poem.author }}</p>
        <p class="text-gray-800 whitespace-pre-line">{{ poem.content }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const { data: poems, pending, error } = await useAsyncData('poems', async () => {
  try {
    const { data: poems, error: supabaseError } = await client
      .from('poems')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (supabaseError) throw supabaseError
    console.log('@@@', poems)
    return poems
  } catch (err) {
    console.error('Error fetching poems:', err)
    throw new Error('Failed to load poems')
  }
})
</script>

<style scoped>
  /* All styles remain the same as in the previous version */
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Lora:ital,wght@0,400;0,600;1,400&display=swap');
  
  .poem-container {
    padding: 20px;
    perspective: 1000px;
  }
  
  .poem-card {
    background: #fff;
    padding: 2.5rem;
    margin-bottom: 2rem;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: default;
    max-width: 700px;
    margin: 0 auto;
    position: relative;
  }
  
  .poem-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 24px rgba(0,0,0,0.1);
  }
  
  /* Border Styles */
  .classic {
    border: double 4px #8b4513;
    background-color: #fff9f0;
    box-shadow: 0 4px 8px rgba(139, 69, 19, 0.2);
  }
  
  .vintage {
    border: 1px solid #795548;
    background-color: #f5e6d3;
    position: relative;
    box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
  }
  
  .vintage::before {
    content: '';
    position: absolute;
    top: 5px;
    left: 5px;
    right: 5px;
    bottom: 5px;
    border: 1px solid #795548;
    pointer-events: none;
  }
  
  .modern {
    border: none;
    border-left: 5px solid #2196f3;
    box-shadow: 0 2px 15px rgba(0,0,0,0.1);
  }
  
  .minimalist {
    border: 1px solid #e0e0e0;
    background-color: #ffffff;
  }
  
  .poem-title {
    font-size: 2.2rem;
    color: #2c3e50;
    margin-bottom: 0.8rem;
    font-family: 'Playfair Display', serif;
    font-weight: 700;
    letter-spacing: -0.02em;
    line-height: 1.2;
  }
  
  .poem-author {
    color: #666;
    font-family: 'Cormorant Garamond', serif;
    font-style: italic;
    font-size: 1.2rem;
    margin-bottom: 2rem;
  }
  
  .poem-content {
    font-family: 'Lora', serif;
    line-height: 1.9;
    max-height: 300px;
    overflow: hidden;
    transition: max-height 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    font-size: 1.1rem;
    color: #2c3e50;
    white-space: pre-line;
  }
  
  .poem-content.expanded {
    max-height: 2000px;
  }
  
  .poem-line {
    margin: 0.7rem 0;
    transition: opacity 0.3s ease;
  }
  
  .fade-bottom {
    position: relative;
  }
  
  .fade-bottom::after {
    content: '';
    position: absolute;
    bottom: -80px;
    left: 0;
    width: 100%;
    height: 80px;
    background: linear-gradient(transparent, #fff);
    pointer-events: none;
  }
  
  .expand-button {
    background: transparent;
    border: none;
    color: #2196f3;
    font-family: 'Cormorant Garamond', serif;
    font-size: 1.1rem;
    padding: 0.5rem 1rem;
    margin-top: 1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    z-index: 2;
  }
  
  .expand-button:hover {
    color: #1976d2;
    text-decoration: underline;
  }
  
  .expand-button:focus {
    outline: none;
    box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.2);
    border-radius: 4px;
  }
  
  .poem-footer {
    margin-top: 2rem;
    text-align: right;
    font-size: 1rem;
    color: #666;
    font-family: 'Cormorant Garamond', serif;
  }
  
  .poem-date {
    font-style: italic;
  }
  
  /* Animation for expansion */
  .poem-card.expanded {
    transform: translateY(0);
  }
  
  @media (max-width: 768px) {
    .poem-card {
      padding: 1.5rem;
    }
    
    .poem-title {
      font-size: 1.8rem;
    }
    
    .poem-content {
      font-size: 1rem;
      line-height: 1.8;
    }
  }
  </style>
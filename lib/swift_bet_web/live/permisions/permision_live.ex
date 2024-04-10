defmodule SwiftBetWeb.Permisions.PermisionsLive do

    use SwiftBetWeb, :live_view


    def render(assigns)do
        
        ~H"""

<div class="w-full max-w-xl  mx-auto">
  <form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
    <div class="mb-4">
      <label class="block text-gray-700 text-sm font-bold mb-2" for="role">
        Role
      </label>
      <select id="role" name="role" class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        <option value="admin">Admin</option>
        <option value="editor">Editor</option>
        <option value="viewer">Viewer</option>
      </select>
    </div>
    <div class="mb-6">
      <label class="block text-gray-700 text-sm font-bold mb-2">
        Permissions
      </label>
      <div class="grid grid-cols-2 gap-4">
        <label class="flex items-center">
          <input type="checkbox" class="form-checkbox" name="permission1">
          <span class="ml-2 text-gray-700">Permission 1</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" class="form-checkbox" name="permission2">
          <span class="ml-2 text-gray-700">Permission 2</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" class="form-checkbox" name="permission3">
          <span class="ml-2 text-gray-700">Permission 3</span>
        </label>
        <label class="flex items-center">
          <input type="checkbox" class="form-checkbox" name="permission3">
          <span class="ml-2 text-gray-700">Permission 3</span>
        </label>
      </div>
    </div>
    <div class="flex items-center justify-between">
      <button type="button" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
        Save
      </button>
    </div>
  </form>
</div>

        """
    end

    def  mount(_session, __params, socket)do
        
        {:ok, socket}
    end
    
end
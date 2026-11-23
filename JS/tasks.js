
let tasks = JSON.parse(localStorage.getItem("tasks")) || [];

const todo = document.getElementById("todo");
const inprogress = document.getElementById("inprogress");
const completed = document.getElementById("completed");

function saveTasks() {
    localStorage.setItem("tasks", JSON.stringify(tasks));
}

function renderTasks() {
    todo.innerHTML = "";
    inprogress.innerHTML = "";
    completed.innerHTML = "";

    let sortType = document.getElementById("sort").value;
    let sortedTasks = [...tasks];

    if (sortType === "priority") {
        const order = { High: 1, Medium: 2, Low: 3 };

        sortedTasks.sort((a, b) =>
            order[a.priority] - order[b.priority]
        );
    }

    if (sortType === "dueDate") {
        sortedTasks.sort((a, b) => {
            if (!a.dueDate) return 1;
            if (!b.dueDate) return -1;

            return a.dueDate.localeCompare(b.dueDate);
        });
    }

    sortedTasks.forEach(task => {
        const card = document.createElement("div");
        card.className = "task";

        const focusCheckbox = document.createElement("input");
        focusCheckbox.type = "checkbox";
        focusCheckbox.className = "focus-checkbox";
        focusCheckbox.checked = task.focus;

        focusCheckbox.addEventListener("change", () => {
            toggleFocus(task.id);
        });

        const focusLabel = document.createElement("label");
        focusLabel.className = "focus-label";
        focusLabel.appendChild(focusCheckbox);
        focusLabel.append(" Select for focus");

        const title = document.createElement("h3");
        title.textContent = task.title;

        const priority = document.createElement("p");
        priority.className = "priority " + task.priority.toLowerCase();
        priority.textContent = "Priority: " + task.priority;

        const dueDate = document.createElement("p");
        dueDate.textContent = "Due: " + (task.dueDate || "No date");

        const buttons = document.createElement("div");
        buttons.className = "task-buttons";

        const editButton = document.createElement("button");
        editButton.textContent = "Edit";
        editButton.addEventListener("click", () => {
            editTask(task.id);
        });

        const moveButton = document.createElement("button");

        if (task.status === "completed") {
            moveButton.textContent = "Reopen";
        } else {
            moveButton.textContent = "Next Status";
        }

        moveButton.addEventListener("click", () => {
            moveTask(task.id);
        });

        const deleteButton = document.createElement("button");
        deleteButton.textContent = "Delete";
        deleteButton.className = "delete-btn";

        deleteButton.addEventListener("click", () => {
            deleteTask(task.id);
        });

        buttons.append(editButton, moveButton, deleteButton);

        card.append(
            focusLabel,
            title,
            priority,
            dueDate,
            buttons
        );

        if (task.status === "todo") {
            todo.appendChild(card);
        } else if (task.status === "inprogress") {
            inprogress.appendChild(card);
        } else {
            completed.appendChild(card);
        }
    });
}

function editTask(id) {
    let task = tasks.find(t => t.id === id);

    let title = prompt("Edit task name:", task.title);

    if (title === null || title.trim() === "") {
        return;
    }

    let priority = prompt(
        "Priority (Low, Medium, High):",
        task.priority
    );

    if (!["Low", "Medium", "High"].includes(priority)) {
        alert("Invalid priority.");
        return;
    }

    let dueDate = prompt("Due date (YYYY-MM-DD):", task.dueDate);

    if (dueDate === null) {
        return;
    }

    task.title = title.trim();
    task.priority = priority;
    task.dueDate = dueDate;

    saveTasks();
    renderTasks();
}

function deleteTask(id) {
    tasks = tasks.filter(t => t.id !== id);

    saveTasks();
    renderTasks();
}

function moveTask(id) {
    let task = tasks.find(t => t.id === id);

    if (task.status === "todo") {
        task.status = "inprogress";
    } else if (task.status === "inprogress") {
        task.status = "completed";
    } else {
        task.status = "todo";
    }

    saveTasks();
    renderTasks();
}

function toggleFocus(id) {
    let task = tasks.find(t => t.id === id);
    task.focus = !task.focus;

    saveTasks();
    renderTasks();
}

document.getElementById("sort").addEventListener("change", renderTasks);

document.getElementById("focusBtn").addEventListener("click", function(event) {
    let selectedTasks = tasks.filter(t => t.focus);

    if (selectedTasks.length === 0) {
        event.preventDefault();
        alert("Select at least one task for your focus session.");
        return;
    }

    localStorage.setItem("focusTasks", JSON.stringify(selectedTasks));
});

renderTasks();

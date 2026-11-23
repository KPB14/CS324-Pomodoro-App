document.getElementById("taskForm").addEventListener("submit", function(event) {
    event.preventDefault();

    let title = document.getElementById("title").value.trim();
    let priority = document.getElementById("priority").value;
    let dueDate = document.getElementById("dueDate").value;

    if (title === "") return;

    let tasks = JSON.parse(localStorage.getItem("tasks")) || [];

    let newTask = {
        id: Date.now(),
        title: title,
        priority: priority,
        dueDate: dueDate,
        status: "todo",
        focus: false
    };

    tasks.push(newTask);

    localStorage.setItem("tasks", JSON.stringify(tasks));

    window.location.href = "tasks.html";
});
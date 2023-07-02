-- 1. Создание базы данных
CREATE DATABASE {db_name}

-- 2. Создание таблиц для базы данных
CREATE TABLE IF NOT EXISTS companies (
        company_id INT PRIMARY KEY,
        company_name VARCHAR(255) NOT NULL,
        url TEXT
        );

        CREATE TABLE IF NOT EXISTS vacancies (
        vacancy_id SERIAL PRIMARY KEY,
        vacancy_name VARCHAR(255) NOT NULL,
        vacancy_salary INT,
        company_id INT ,
        url TEXT,
        FOREIGN KEY (company_id) REFERENCES companies (company_id)
        );

-- 3. Заполнение таблицы с компаниями
INSERT INTO companies (company_id, company_name, url)
        VALUES (%s, %s, %s)
        ON CONFLICT (company_id) DO UPDATE SET
            company_name = EXCLUDED.company_name,
            url = EXCLUDED.url

-- 4. Заполнение таблицы с вакансиями
INSERT INTO vacancies (vacancy_id, vacancy_name, vacancy_salary, company_id, url)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (vacancy_id) DO UPDATE SET
            vacancy_name = EXCLUDED.vacancy_name,
            vacancy_salary = EXCLUDED.vacancy_salary,
            company_id = EXCLUDED.company_id,
            url = EXCLUDED.url

-- 5. Получение списка компаний с выводом количества вакансий у каждой из них
SELECT c.company_id, c.company_name, COUNT(*) AS vacancy_count
        FROM vacancies v
        JOIN companies c ON v.company_id = c.company_id
        GROUP BY c.company_id, c.company_name
        ORDER BY vacancy_count DESC;

-- 6. Получение списка всех вакансий
SELECT c.company_name, v.vacancy_name, v.vacancy_salary, v.url
        FROM vacancies v
        JOIN companies c ON v.company_id = c.company_id

-- 7. Получение средней зарплаты
SELECT AVG(vacancy_salary) FROM vacancies

--8. Получение списка вакансий с зарплатой больше средней по всем вакансиям
SELECT vacancy_id, vacancy_name, vacancy_salary
        FROM vacancies
        WHERE vacancy_salary > (
          SELECT AVG(vacancy_salary) AS avg_salary
          FROM vacancies
        );

--9. Получение списка вакансий по ключевому слову(ам)
SELECT * FROM vacancies WHERE LOWER(vacancy_name) LIKE LOWER('%{keyword}%')
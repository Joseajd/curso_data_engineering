# 🎾 Tennis Data Pipeline: 2000-2025 (Medallion Architecture)

![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-F29111?style=for-the-badge&logo=mysql&logoColor=white)
![Data Engineering](https://img.shields.io/badge/Data_Engineering-Pipeline-success?style=for-the-badge)

##  Descripción del Proyecto

Este proyecto es un **Pipeline de Datos** de principio a fin (End-to-End) diseñado para procesar, limpiar y modelar 25 años de historia del tenis profesional (2000 - 2025). 

El objetivo principal es tomar datos crudos en formato CSV y transformarlos en un **Modelo de Estrella** optimizado para análisis y Business Intelligence, utilizando las mejores prácticas de la industria y la arquitectura Medallion en Snowflake.

---

##  Arquitectura de Datos (Medallion Architecture)

El flujo de datos está estructurado en tres capas lógicas dentro de Snowflake para garantizar la calidad y trazabilidad de la información:

### 🥉 Capa Bronce (Raw Data)
La zona de aterrizaje de los datos. 
* **Origen:** Archivos CSV extraídos, cada uno con toda la información de un año de competición desde 2000 hasta 2025.
* **Estructura:** Unificación en una tabla (`base_atp_all`) que contiene toda la información sin procesar, manteniendo el formato original para auditoría.
Tambien se ha añadido un archivo CSV con información de todos los países y sus nombres, para posteriormente sustituir las siglas de estos por sus nombres.

### 🥈 Capa Plata / Staging (Cleansed & Conformed)
Aquí ocurre la magia de la ingeniería: limpieza, validación y normalización. La gran tabla de Bronce se separó en entidades lógicas:
* **Entidades de Tiempo y Ubicación:** `stg_date`, `stg_github_tables__countries`.
* **Entidades del Juego:** `stg_github_tables__tournaments`, `stg_github_tables__surfaces`, `stg_github_tables__rounds`.
* **Entidades de Jugadores:** `stg_github_tables__players`, `stg_github_tables__entry_modes`.
* **Hechos Desnormalizados:** `stg_github_tables__matches_stats`.

### 🥇 Capa Oro (Analytics & Star Schema)
Los datos están listos para ser consumidos por herramientas de visualización (Power BI, Tableau, etc.). Se construyó un modelo dimensional enfocado en el rendimiento de las consultas:

| Tipo de Tabla | Nombre | Descripción |
| :--- | :--- | :--- |
| **Fact Table (Hechos)** | `fcts_matches_stats` | Tabla central con las métricas cuantitativas (aces, dobles faltas, puntos ganados, duración del partido, etc). |
| **Dimension (Dimensión)**| `dim_tournaments` | Información sobre el torneo (Grand Slam, Masters 1000, ubicación). |
| **Dimension (Dimensión)**| `dim_players` | Datos demográficos y físicos (nombre, altura, mano dominante, país). |
| **Dimension (Dimensión)**| `dim_surfaces` | Tipo de pista (Clay, Hard, Grass). |
| **Dimension (Dimensión)**| `dim_countries` | Países que aparecen en la tabla y son susceptibles de ser necesitados para consultas. |
| **Dimension (Dimensión)**| `dim_date` | Jerarquía temporal para análisis por temporada, mes o año. |
| **Dimension (Dimensión)**| `dim_entry_modes` | Modos de entrada al torneo. |
| **Dimension (Dimensión)**| `dim_rounds` | Rondas que tiene un torneo. |

---
## Funcionalidades Avanzadas de dbt

Para garantizar la escalabilidad del código y la revisión histórica de los datos, este proyecto implementa características avanzadas de dbt:

* **Macros Personalizadas (Jinja):** Se desarrolló una macro (`nulls.sql`) para automatizar la limpieza de datos. En lugar de escribir sentencias `COALESCE` repetitivas, esta macro evalúa las métricas y transforma dinámicamente los valores nulos (`NULL`) en ceros (`0`), manteniendo el código SQL limpio y aplicando el principio DRY.
* **Snapshots (SCD Tipo 2):** Se configuró un modelo de *Snapshot* para gestionar la evolución temporal de los tenistas (Slowly Changing Dimensions). El sistema monitorea activamente la tabla de jugadores y, si detecta una variación en la cantidad de partidos jugados en el año actual, genera un nuevo registro histórico válido. Esto permite hacer consultas "Point-in-Time" (saber exactamente cuál era el estado de un jugador en una fecha pasada).

---
## Estructura del Repositorio (dbt Project)

El proyecto utiliza **dbt (data build tool)** para orquestar las transformaciones de datos en Snowflake. La estructura del repositorio sigue las mejores prácticas de modularidad, reflejando el linaje exacto desde la ingesta hasta los modelos de consumo (Medallion Architecture).

Se han omitido las carpetas predeterminadas de dbt que no tienen uso activo en este proyecto para mantener la limpieza del repositorio.

```text
📁 tennis-data-pipeline/
│
├── 📁 models/                  
│   │
│   ├── 📁 staging/             # 🥈 Capa Silver (Limpieza, casteo y estandarización)
│   │   └── 📁 github_tables/
│   │       ├── 📁 base/        # Vistas efímeras para renombrado inicial
│   │       │   ├── base_atp_matches.sql
│   │       │   └── base_countries.sql
│   │       │
│   │       ├── stg_github_tables__matches.sql
│   │       ├── stg_github_tables__players.sql
│   │       ├── stg_github_tables__tournaments.sql
│   │       ├── ...             # (Resto de modelos stg_)
│   │       ├── _sources.yml    # 🥉 Definición de las fuentes en Snowflake (Capa Bronze)
│   │       └── _staging.yml    # Tests y descripciones de la capa staging
│   │
│   └── 📁 marts/               # 🥇 Capa Gold (Modelado dimensional y agregaciones)
│       ├── 📁 core/            # Modelo de Estrella (Fuente única de la verdad)
│       │   ├── dim_players.sql
│       │   ├── dim_tournaments.sql
│       │   ├── fcts_matches.sql
│       │   ├── ...             # (Resto de dimensiones)
│       │   └── _core.yml       # Tests (unique, not_null) y documentación del core
│       │
│       └── 📁 players/         # Modelos de negocio listos para BI (Reporting)
│           ├── players_stats.sql
│           ├── player_stats_evolution.sql
│           └── _players.yml    # Tests y documentación de las métricas finales
│
├── 📁 tests/                   # Tests singulares y personalizados de data quality
├── 📁 macros/                  # Funciones Jinja reutilizables
│   └── null_to_zero.sql        # Macro para casteo automático de nulos a ceros
│
├── 📁 snapshots/               # SCD Tipo 2 (Historial de cambios)
│   └── players_snapshot.sql    # Captura de evolución de partidos jugados por año
├── .gitignore                  # Archivos ignorados por Git
├── dbt_project.yml             # Configuración principal del proyecto y variables
├── packages.yml                # Dependencias y paquetes de dbt (ej. dbt-utils)
├── package-lock.yml            # Control de versiones de los paquetes
└── README.md                   # Documentación principal del proyecto

---



